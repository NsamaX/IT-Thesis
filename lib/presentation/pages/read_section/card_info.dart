import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/locales/localizations.dart';
import '../../../domain/entities/card.dart';
import '../../blocs/deck_manager.dart';
import '../../blocs/NFC.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/card/details.dart';
import '../../widgets/dialog.dart';

class CardInfoPage extends StatefulWidget {
  @override
  _CardInfoPageState createState() => _CardInfoPageState();
}

class _CardInfoPageState extends State<CardInfoPage>
    with WidgetsBindingObserver {
  late NFCCubit _nfcCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _nfcCubit = context.read<NFCCubit>();
    debugPrint('CardInfoPage: initState');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _stopNFCSession('App moved to background: $state');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopNFCSession('Page disposed');
    super.dispose();
  }

  void _stopNFCSession(String reason) {
    try {
      final nfcCubit = context.read<NFCCubit>();
      if (!nfcCubit.isClosed && nfcCubit.state.isNFCEnabled) {
        nfcCubit.stopSession();
        debugPrint('NFC session stopped: $reason');
      }
    } catch (e) {
      debugPrint('Error stopping NFC session: $e');
    }
  }

  void _handleSnackBar(BuildContext context, NFCState state) {
    if (state.isOperationSuccessful) {
      showSnackBar(
        context,
        AppLocalizations.of(context)
            .translate('card_info.dialog.write_success'),
      );
      _nfcCubit.resetOperationStatus();
    } else if (state.errorMessage != null) {
      showSnackBar(
        context,
        AppLocalizations.of(context).translate('card_info.dialog.write_fail'),
      );
      _nfcCubit.clearErrorMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final card = arguments?['card'] as CardEntity?;
    final isAdd = arguments?['isAdd'] ?? false;
    final isCustom = arguments?['isCustom'] ?? false;
    final TextEditingController deckNameController = TextEditingController(
      text: AppLocalizations.of(context).translate('card_info.card_name'),
    );

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
                ? AppLocalizations.of(context).translate('card_info.title')
                : TextField(
                    controller: deckNameController,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)
                          .translate('card_info.card_name'),
                    ),
                    onSubmitted: (value) {
                      final newName = value.trim().isNotEmpty
                          ? value.trim()
                          : AppLocalizations.of(context)
                              .translate('card_info.card_name');
                      deckNameController.text = newName;
                    },
                  ): null,
            if (isAdd)
              AppLocalizations.of(context).translate('card_info.add'): () {
                if (card != null) {
                  context.read<DeckManagerCubit>().addCard(card);
                  Navigator.pop(context);
                  showSnackBar(
                    context,
                    AppLocalizations.of(context)
                        .translate('card_info.dialog.add'),
                  );
                }
              },
            if (isCustom)
              AppLocalizations.of(context).translate('card_info.save'): null,
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
