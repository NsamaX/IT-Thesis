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

  @override
  void initState() {
    super.initState();
    _nfcCubit = context.read<NFCCubit>();
    _nfcSessionHandler = NFCSessionHandler(_nfcCubit);
    _nfcSessionHandler.initNFCSessionHandler();
  }

  @override
  void dispose() {
    _nfcSessionHandler.disposeNFCSessionHandler();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _nfcSessionHandler.handleAppLifecycleState(state);
  }

  Map<dynamic, dynamic> _buildAppBarMenu(
    BuildContext context,
    AppLocalizations locale,
    CardEntity? card,
    bool isAdd,
    bool isCustom,
    TextEditingController deckNameController,
  ) {
    final deckManagerCubit = context.read<DeckManagerCubit>();
    final nfcCubit = context.watch<NFCCubit>();
    final isNFCEnabled = nfcCubit.state.isNFCEnabled;

    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      isCustom
          ? TextField(
              controller: deckNameController,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: locale.translate('text.card_name'),
              ),
              onSubmitted: (value) {
                final newName = value.trim().isNotEmpty
                    ? value.trim()
                    : locale.translate('text.card_name');
                deckNameController.text = newName;
              },
            )
          : locale.translate('title.card'): null,
      if (isAdd)
        locale.translate('toggle.add'): () {
          context.read<DeckManagerCubit>().addCard(card!, deckManagerCubit.state.quantity);
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
    final deckNameController = TextEditingController(text: locale.translate('text.card_name'));

    return Scaffold(
      appBar: AppBarWidget(
        menu: _buildAppBarMenu(
          context,
          locale,
          card,
          isAdd,
          isCustom,
          deckNameController,
        ),
      ),
      body: BlocBuilder<DeckManagerCubit, DeckManagerState>(
        builder: (context, state) {
          final deckManagerCubit = context.read<DeckManagerCubit>();

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
                  onSelected: (quantity) => deckManagerCubit.setQuantity(quantity),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
