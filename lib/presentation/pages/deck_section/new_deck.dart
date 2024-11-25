import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/locales/localizations.dart';
import '../../../core/routes/route.dart';
import '../../blocs/deck_manager.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/card/card.dart';
import '../../widgets/dialog.dart';

class NewDeckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deck = context.read<DeckMangerCubit>().state.deck;
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBarWidget(
            menu: !context.watch<DeckMangerCubit>().state.isEditMode
                ? {
                    Icons.window_rounded: '/back',
                    Icons.upload_rounded: () {
                      context.read<DeckMangerCubit>().toggleShare();
                      showSnackBar(
                        context,
                        AppLocalizations.of(context)
                            .translate('new_deck.dialog.share'),
                      );
                    },
                    deck.deckName: null,
                    Icons.play_arrow_rounded: AppRoutes.track,
                    Icons.build_outlined: () =>
                        context.read<DeckMangerCubit>().toggleEditMode(),
                  }
                : {
                    Icons.nfc_rounded: () =>
                        context.read<DeckMangerCubit>().toggleNfcRead(),
                    Icons.delete_rounded: () {
                      showCupertinoAlertCancle(
                        context,
                        AppLocalizations.of(context)
                            .translate('new_deck.dialog.delete.title'),
                        AppLocalizations.of(context)
                            .translate('new_deck.dialog.delete.content'),
                        () {
                          context.read<DeckMangerCubit>().toggleDelete();
                          showSnackBar(
                            context,
                            AppLocalizations.of(context)
                                .translate('new_deck.dialog.delete.success'),
                          );
                        },
                      );
                    },
                    deck.deckName: null,
                    Icons.search_rounded: {
                      'route': AppRoutes.other,
                      'arguments': {'isAdd': true},
                    },
                    Icons.build_outlined: () =>
                        context.read<DeckMangerCubit>().toggleEditMode(),
                  },
          ),
          body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: context.read<DeckMangerCubit>().state.deck.cards.length,
            itemBuilder: (context, index) {
              final deckCards =
                  context.read<DeckMangerCubit>().state.deck.cards;
              final card = deckCards.keys.toList()[index];
              final count = deckCards[card]!;
              return CardWidget(
                card: card,
                count: count,
              );
            },
          ),
        );
      },
    );
  }
}
