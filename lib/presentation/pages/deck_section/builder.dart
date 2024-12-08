import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/route.dart';
import '../../blocs/deck_manager.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/card/card.dart';
import '../../widgets/dialog.dart';

class BuilderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<DeckManagerCubit>(); 
    final deck = cubit.state.deck;
    final TextEditingController deckNameController = TextEditingController(text: deck.deckName);
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBarWidget(
            menu: !context.watch<DeckManagerCubit>().state.isEditMode
                ? {
                    Icons.arrow_back_ios_new_rounded: () {
                      cubit.saveDeck();
                      Navigator.of(context).pop();
                    },
                    Icons.ios_share_rounded: () {
                      cubit.toggleShare();
                      showSnackBar(
                        context,
                        locale.translate('builder.dialog.share'),
                      );
                    },
                    cubit.state.deck.deckName: null,
                    Icons.play_arrow_rounded: AppRoutes.tracker,
                    locale.translate('builder.toggle.edit'): () => cubit.toggleEditMode(),
                  }
                : {
                    Icons.nfc_rounded: () => cubit.toggleNfcRead(),
                    Icons.delete_outline_rounded: () {
                      showCupertinoAlertCancle(
                        context,
                        locale.translate('builder.dialog.delete.title'),
                        locale.translate('builder.dialog.delete.content'),
                        () {
                          cubit.toggleDelete();
                          showSnackBar(
                            context,
                            locale.translate('builder.dialog.delete.success'),
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
                        hintText: locale.translate('builder.title'),
                      ),
                      onSubmitted: (value) {
                        final newName = value.trim().isNotEmpty
                            ? value.trim()
                            : locale.translate('builder.title');
                        cubit.renameDeck(newName);
                        deckNameController.text = newName;
                      },
                    ): null,
                    Icons.add_rounded: {
                      'route': AppRoutes.games,
                      'arguments': {'isAdd': true},
                    },
                    locale.translate('builder.toggle.save'): () => cubit.toggleEditMode(),
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
              final deckCards = cubit.state.deck.cards;
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
