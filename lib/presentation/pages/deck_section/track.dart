import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/presentation/blocs/NFC.dart';
import '../../../core/locales/localizations.dart';
import '../../blocs/deck_manager.dart';
import '../../blocs/tracker.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/dialog.dart';
import '../../widgets/label/card.dart';

class TrackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deck = context.read<DeckManagerCubit>().state.deck;
    return BlocProvider(
      create: (context) => TrackCubit(deck),
      child: MultiBlocListener(
        listeners: [
          BlocListener<NFCCubit, NFCState>(
            listener: (context, nfcState) async {
              final tag = nfcState.lastReadTag;
              if (tag != null && nfcState.isNFCEnabled) {
                try {
                  context.read<TrackCubit>().readTag(tag);
                  showSnackBar(
                    context,
                    AppLocalizations.of(context)
                        .translate('card_info.dialog.read_success'),
                  );
                } catch (e) {
                  showSnackBar(
                    context,
                    AppLocalizations.of(context)
                        .translate('card_info.dialog.read_fail'),
                  );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<TrackCubit, TrackState>(
          builder: (context, state) {
            final totalCards = context.read<TrackCubit>().totalCards;
            if (!state.isDialogShown) {
              Future.microtask(() {
                context.read<TrackCubit>().showDialog();
                showCupertinoAlertOK(
                  context,
                  AppLocalizations.of(context).translate('track.dialog.title'),
                  AppLocalizations.of(context)
                      .translate('track.dialog.content'),
                );
              });
            }
            return Scaffold(
              appBar: AppBarWidget(
                menu: {
                  Icons.arrow_back_ios_new_rounded: '/back',
                  totalCards.toString(): null,
                  AppLocalizations.of(context).translate('track.title'): null,
                  Icons.refresh_rounded: () {
                    context.read<TrackCubit>().toggleReset(deck);
                  },
                  context.watch<NFCCubit>().state.isNFCEnabled
                      ? Icons.wifi_tethering_rounded
                      : Icons.wifi_tethering_off_rounded: () async {
                    final nfcCubit = context.read<NFCCubit>();
                    if (!nfcCubit.isClosed) {
                      nfcCubit.toggleNFC();
                      if (nfcCubit.state.isNFCEnabled) {
                        await nfcCubit.start();
                      }
                    } else {
                      debugPrint('NFCCubit is already closed.');
                    }
                  },
                },
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: ListView.builder(
                  itemCount: state.deck.cards.length,
                  itemBuilder: (context, index) {
                    final entry = state.deck.cards.entries.elementAt(index);
                    final card = entry.key;
                    final count = entry.value;
                    return CardLabelWidget(
                      card: card,
                      count: count,
                      lightTheme: count > 0,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
