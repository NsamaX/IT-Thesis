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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nfcCubit = context.read<NFCCubit>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nfcCubit.stopSession();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      _nfcCubit.stopSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final card = arguments?['card'] as CardEntity?;
    final isAdd = arguments?['isAdd'] ?? false;
    final isCustom = arguments?['isCustom'] ?? false;

    return BlocListener<NFCCubit, NFCState>(
      listener: (context, state) {
        if (state.isOperationSuccessful) {
          showSnackBar(
            context,
            AppLocalizations.of(context)
                .translate('card_info.dialog.write_success'),
          );
          context
              .read<NFCCubit>()
              // ignore: invalid_use_of_visible_for_testing_member
              .emit(state.copyWith(isOperationSuccessful: false));
        } else if (state.errorMessage != null) {
          showSnackBar(
            context,
            AppLocalizations.of(context)
                .translate('card_info.dialog.write_error'),
          );
          // ignore: invalid_use_of_visible_for_testing_member
          context.read<NFCCubit>().emit(state.copyWith(errorMessage: null));
        }
      },
      child: Scaffold(
        appBar: AppBarWidget(
          menu: {
            Icons.arrow_back_ios_new_rounded: '/back',
            AppLocalizations.of(context).translate('card_info.title'): null,
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
            if (!isAdd && !isCustom)
              context.watch<NFCCubit>().state.isNFCEnabled
                  ? Icons.wifi_tethering_rounded
                  : Icons.wifi_tethering_off_rounded: () {
                final nfcCubit = context.read<NFCCubit>();
                nfcCubit.toggleNFC();
                if (nfcCubit.state.isNFCEnabled && card != null) {
                  nfcCubit.startWrite(card);
                }
              },
          },
        ),
        body: CardDetailsWidget(card: card, isCustom: isCustom),
      ),
    );
  }
}
