import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      child: BlocBuilder<TrackCubit, TrackState>(
        builder: (context, state) {
          final totalCards = context.read<TrackCubit>().totalCards;
          if (!state.isDialogShown) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<TrackCubit>().showDialog();
              showCupertinoAlertOK(
                context,
                AppLocalizations.of(context).translate('track.dialog.title'),
                AppLocalizations.of(context).translate('track.dialog.content'),
              );
            });
          }
          return Scaffold(
            appBar: AppBarWidget(
              menu: {
                Icons.arrow_back_ios_new_rounded: '/back',
                totalCards.toString(): null,
                AppLocalizations.of(context).translate('track.title'): null,
                Icons.refresh_rounded: null,
                context.watch<TrackCubit>().state.isNfcReadEnabled
                        ? Icons.wifi_tethering_rounded
                        : Icons.wifi_tethering_off_rounded:
                    context.read<TrackCubit>().toggleNfcRead,
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
                    lightTheme: count > 0 ? true : false,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
