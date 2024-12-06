import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/route.dart';
import '../../blocs/deck_manager.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/card/card.dart';
import '../../widgets/dialog.dart';

class NewDeckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deck = context.read<DeckManagerCubit>().state.deck;
    final TextEditingController deckNameController =
        TextEditingController(text: deck.deckName);
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBarWidget(
            menu: !context.watch<DeckManagerCubit>().state.isEditMode
                ? {
                    Icons.arrow_back_ios_new_rounded: '/back',
                    Icons.upload_rounded: () {
                      context.read<DeckManagerCubit>().toggleShare();
                      showSnackBar(
                        context,
                        AppLocalizations.of(context)
                            .translate('new_deck.dialog.share'),
                      );
                    },
                    TextField(
                      controller: deckNameController,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)
                            .translate('new_deck.title'),
                      ),
                      onSubmitted: (value) {
                        final newName = value.trim().isNotEmpty
                            ? value.trim()
                            : AppLocalizations.of(context)
                                .translate('new_deck.title');
                        context.read<DeckManagerCubit>().renameDeck(newName);
                        deckNameController.text = newName;
                      },
                    ): null,
                    Icons.play_arrow_rounded: AppRoutes.track,
                    AppLocalizations.of(context)
                            .translate('new_deck.menu.edit'):
                        () => context.read<DeckManagerCubit>().toggleEditMode(),
                  }
                : {
                    Icons.nfc_rounded: () =>
                        context.read<DeckManagerCubit>().toggleNfcRead(),
                    Icons.delete_outline_rounded: () {
                      showCupertinoAlertCancle(
                        context,
                        AppLocalizations.of(context)
                            .translate('new_deck.dialog.delete.title'),
                        AppLocalizations.of(context)
                            .translate('new_deck.dialog.delete.content'),
                        () {
                          context.read<DeckManagerCubit>().toggleDelete();
                          showSnackBar(
                            context,
                            AppLocalizations.of(context)
                                .translate('new_deck.dialog.delete.success'),
                          );
                        },
                      );
                    },
                    TextField(
                      controller: deckNameController,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)
                            .translate('new_deck.title'),
                      ),
                      onSubmitted: (value) {
                        final newName = value.trim().isNotEmpty
                            ? value.trim()
                            : AppLocalizations.of(context)
                                .translate('new_deck.title');
                        context.read<DeckManagerCubit>().renameDeck(newName);
                        deckNameController.text = newName;
                      },
                    ): null,
                    Icons.add: {
                      'route': AppRoutes.hub,
                      'arguments': {'isAdd': true},
                    },
                    AppLocalizations.of(context)
                            .translate('new_deck.menu.done'):
                        () => context.read<DeckManagerCubit>().toggleEditMode(),
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
            itemCount: context.read<DeckManagerCubit>().state.deck.cards.length,
            itemBuilder: (context, index) {
              final deckCards =
                  context.read<DeckManagerCubit>().state.deck.cards;
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
