import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../../blocs/deck_manager.dart';
import '../../blocs/NFC.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/card/details.dart';
import '../../widgets/dialog.dart';

class CardPage extends StatefulWidget {
  @override
  _CardInfoPageState createState() => _CardInfoPageState();
}

class _CardInfoPageState extends State<CardPage> with WidgetsBindingObserver {
  late NFCCubit _nfcCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _nfcCubit = context.read<NFCCubit>();
    debugPrint('CardPage: initState');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopNFCSession('Page disposed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _stopNFCSession('App moved to background: $state');
    }
  }

  void _stopNFCSession(String reason) {
    try {
      final nfcCubit = context.read<NFCCubit>();
      if (!nfcCubit.isClosed && nfcCubit.state.isNFCEnabled) {
        nfcCubit.stopSession(reason: reason);
        debugPrint('NFC session stopped: $reason');
      }
    } catch (e) {
      debugPrint('Error stopping NFC session: $e');
    }
  }

  void _handleSnackBar(BuildContext context, NFCState state) {
    final locale = AppLocalizations.of(context);
    if (state.isOperationSuccessful) {
      showSnackBar(
        context,
        locale.translate('card.dialog.write_success'),
      );
      _nfcCubit.resetOperationStatus();
    } else if (state.errorMessage != null) {
      showSnackBar(
        context,
        locale.translate('card.dialog.write_fail'),
      );
      _nfcCubit.clearErrorMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final card = arguments?['card'] as CardEntity?;
    final isAdd = arguments?['isAdd'] ?? false;
    final isCustom = arguments?['isCustom'] ?? false;
    final TextEditingController deckNameController = TextEditingController(text: locale.translate('card.card_name'));
    return BlocListener<NFCCubit, NFCState>(
      listener: (context, state) => _handleSnackBar(context, state),
      child: Scaffold(
        appBar: AppBarWidget(
          menu: {
            Icons.arrow_back_ios_new_rounded: () {
              _stopNFCSession('Navigating back');
              Navigator.of(context).pop();
            },
            isAdd
                ? locale.translate('card.title')
                : TextField(
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
                  ): null,
            if (isAdd) locale.translate('card.toggle.add'): () {
              if (card != null) {
                context.read<DeckManagerCubit>().addCard(card);
                Navigator.pop(context);
                showSnackBar(
                  context,
                  locale.translate('card.dialog.add_success'),
                );
              }
            },
            if (isCustom) locale.translate('card.toggle.done'): null,
            if (!isAdd && !isCustom)
              context.watch<NFCCubit>().state.isNFCEnabled
                  ? Icons.wifi_tethering_rounded
                  : Icons.wifi_tethering_off_rounded: () {
                final nfcCubit = context.read<NFCCubit>();
                if (!nfcCubit.isClosed) {
                  nfcCubit.toggleNFC();
                } else {
                  debugPrint('NFCCubit is already closed.');
                }
                if (nfcCubit.state.isNFCEnabled && card != null) {
                  nfcCubit.start(card: card);
                }
              },
          },
        ),
        body: CardDetailsWidget(card: card, isCustom: isCustom),
      ),
    );
  }
}
