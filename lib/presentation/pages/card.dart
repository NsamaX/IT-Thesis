import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../cubits/deck_manager.dart';
import '../cubits/NFC.dart';
import '../widgets/card/info/quantity.dart';
import '../widgets/card/info/info.dart';
import '../widgets/card/info/image.dart';
import '../widgets/dialog.dart';
import '../widgets/navigation_bar/app.dart';

class CardPage extends StatefulWidget {
  @override
  _CardInfoPageState createState() => _CardInfoPageState();
}

class _CardInfoPageState extends State<CardPage> with WidgetsBindingObserver {
  late final NFCCubit _nfcCubit;
  late final NFCSessionHandler _nfcSessionHandler;
  late TextEditingController _deckNameController;

  @override
  void initState() {
    super.initState();
    _nfcCubit = context.read<NFCCubit>();
    _nfcSessionHandler = NFCSessionHandler(_nfcCubit);
    _nfcSessionHandler.initNFCSessionHandler();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = AppLocalizations.of(context);
    _deckNameController = TextEditingController(text: locale.translate('text.card_name'));
  }

  @override
  void dispose() {
    _nfcSessionHandler.disposeNFCSessionHandler();
    _deckNameController.dispose();
    super.dispose();
  }

  Map<dynamic, dynamic> _buildAppBarMenu({
    required BuildContext context,
    required AppLocalizations locale,
    required CardEntity? card,
    required bool isAdd,
    required bool isCustom,
  }) {
    final deckManagerCubit = context.read<DeckManagerCubit>();
    final nfcCubit = context.watch<NFCCubit>();
    final isNFCEnabled = nfcCubit.state.isNFCEnabled;

    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      isCustom
          ? TextField(
              controller: _deckNameController,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: locale.translate('text.card_name'),
              ),
              onSubmitted: (value) {
                _deckNameController.text = value.trim().isNotEmpty
                    ? value.trim()
                    : locale.translate('text.card_name');
              },
            )
          : locale.translate('title.card'): null,
      if (isAdd)
        locale.translate('toggle.add'): () {
          deckManagerCubit.addCard(card!, deckManagerCubit.state.quantity);
          Navigator.of(context).pop();
          showSnackBar(
            context: context,
            content: locale.translate('snack_bar.card.add_success'),
          );
        },
      if (isCustom) locale.translate('toggle.done'): null,
      if (!isAdd && !isCustom)
        isNFCEnabled
            ? Icons.wifi_tethering_rounded
            : Icons.wifi_tethering_off_rounded: () {
          NFCHelper.handleToggleNFC(nfcCubit,
              enable: !isNFCEnabled,
              card: card,
              reason: 'User toggled NFC in Card Page');
        },
    };
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final card = arguments?['card'] as CardEntity?;
    final isAdd = arguments?['isAdd'] ?? false;
    final isCustom = arguments?['isCustom'] ?? false;

    return Scaffold(
      appBar: AppBarWidget(
        menu: _buildAppBarMenu(
          context: context,
          locale: locale,
          card: card,
          isAdd: isAdd,
          isCustom: isCustom,
        ),
      ),
      body: BlocBuilder<DeckManagerCubit, DeckManagerState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(40),
            children: [
              CardImageWidget(card: card, isCustom: isCustom),
              const SizedBox(height: 24),
              CardInfoWidget(card: card, isCustom: isCustom),
              if (isAdd) ...[
                const SizedBox(height: 24),
                QuantityWidget(
                  quantityCount: 4,
                  selectedQuantity: state.quantity,
                  onSelected: (quantity) => context.read<DeckManagerCubit>().setQuantity(quantity),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
