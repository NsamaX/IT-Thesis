import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../../cubits/deck_manager.dart';
import '../../cubits/NFC.dart';
import '../../widgets/card/info/count.dart';
import '../../widgets/card/info/info.dart';
import '../../widgets/card/info/image.dart';
import '../../widgets/dialog.dart';
import '../../widgets/navigation_bar/app.dart';

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

  void _handleSnackBar(BuildContext context, NFCState state) {
    debugPrint('SnackBar Handler Called: $state');
    final locale = AppLocalizations.of(context);
    if (state.isOperationSuccessful) {
      debugPrint('Operation Successful');
      showSnackBar(
        context: context,
        content: locale.translate('card.dialog.write_success'),
      );
      _nfcCubit.resetOperationStatus();
    } else if (state.errorMessage != null) {
      debugPrint('Error Message: ${state.errorMessage}');
      showSnackBar(
        context: context,
        content: locale.translate('card.dialog.write_fail'),
      );
      _nfcCubit.clearErrorMessage();
    }
  }

  Map<dynamic, dynamic> _buildAppBarMenu(
    BuildContext context,
    AppLocalizations locale,
    CardEntity? card,
    bool isAdd,
    bool isCustom,
    TextEditingController deckNameController,
  ) {
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
                hintText: locale.translate('card.card_name'),
              ),
              onSubmitted: (value) {
                final newName = value.trim().isNotEmpty
                    ? value.trim()
                    : locale.translate('card.card_name');
                deckNameController.text = newName;
              },
            )
          : locale.translate('card.title'): null,
      if (isAdd)
        locale.translate('card.toggle.add'): () {
          context.read<DeckManagerCubit>().addCard(card!);
          Navigator.of(context).pop();
          showSnackBar(
            context: context,
            content: locale.translate('card.dialog.add_success'),
          );
        },
      if (isCustom) locale.translate('card.toggle.done'): null,
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
    final deckNameController = TextEditingController(text: locale.translate('card.card_name'));

    return BlocListener<NFCCubit, NFCState>(
      listener: (context, state) {
        if (state.isOperationSuccessful) {
          _handleSnackBar(context, state);
        } else if (state.errorMessage != null) {
          _handleSnackBar(context, state);
        }
      },
      child: Scaffold(
        appBar: AppBarWidget(
          menu: _buildAppBarMenu(
            context,
            locale,
            card,
            isAdd,
            isCustom,
            deckNameController,
        )),
        body: ListView(
          padding: const EdgeInsets.all(40),
          children: [
            CardImageWidget(card: card, isCustom: isCustom),
            const SizedBox(height: 24),
            CardInfoWidget(card: card, isCustom: isCustom),
            const SizedBox(height: 24),
            CardCountWidget(),
          ],
        ),
      ),
    );
  }
}
