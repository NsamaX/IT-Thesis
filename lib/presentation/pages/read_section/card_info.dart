import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../../blocs/deck_manager.dart';
import '../../blocs/NFC.dart';
import '../NFC_service.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/card/details.dart';
import '../../widgets/dialog.dart';

class CardInfoPage extends StatefulWidget {
  @override
  _CardInfoPageState createState() => _CardInfoPageState();
}

class _CardInfoPageState extends State<CardInfoPage> {
  late NFCService _nfcService;
  late NFCCubit _nfcCubit;

  @override
  void initState() {
    super.initState();
    _nfcCubit = context.read<NFCCubit>();
    _nfcService = NFCService(_nfcCubit);
    debugPrint('CardInfoPage: initState');
  }

  @override
  void dispose() {
    _nfcService.dispose();
    super.dispose();
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
        state.errorMessage ??
            AppLocalizations.of(context)
                .translate('card_info.dialog.write_fail'),
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
            Icons.arrow_back_ios_new_rounded: '/back',
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
                if (!_nfcCubit.isClosed &&
                    !context.read<NFCCubit>().state.isProcessing) {
                  _nfcCubit.toggleNFC();
                  if (_nfcCubit.state.isNFCEnabled && card != null) {
                    _nfcCubit.start(card: card);
                  }
                } else {
                  showSnackBar(
                      context, "NFC is already processing. Please wait.");
                }
              },
          },
        ),
        body: CardDetailsWidget(card: card, isCustom: isCustom),
      ),
    );
  }
}
