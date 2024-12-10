import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import '../../blocs/deck_manager.dart';
import '../../widgets/card/grid.dart';
import '../../widgets/dialog.dart';
import '../../widgets/navigation_bar/app.dart';

class NewDeckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<DeckManagerCubit>();
    final deck = cubit.state.deck;
    final TextEditingController deckNameController = TextEditingController(text: deck.deckName);

    return Scaffold(
      appBar: AppBarWidget(menu: _buildMenu(context, cubit, locale, deckNameController)),
      body: _buildGridView(context, cubit),
    );
  }

  Map<dynamic, dynamic> _buildMenu(
    BuildContext context,
    DeckManagerCubit cubit,
    AppLocalizations locale,
    TextEditingController deckNameController,
  ) {
    final state = context.watch<DeckManagerCubit>().state;
    final bool isEditMode = state.isEditMode;
    final bool hasCards = state.deck.cards.isNotEmpty;

    if (!isEditMode && !hasCards) {
      return {
        Icons.arrow_back_ios_new_rounded: '/back',
        state.deck.deckName: null,
        locale.translate('new_deck.toggle.edit'): () => cubit.toggleEditMode(),
      };
    }

    return isEditMode
        ? {
            Icons.nfc_rounded: () => cubit.toggleNfcRead(),
            Icons.delete_outline_rounded: () => _showDeleteDialog(context, cubit, locale),
            TextField(
              controller: deckNameController,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: locale.translate('new_deck.title'),
              ),
              onSubmitted: (value) => _renameDeck(cubit, deckNameController, locale, value),
            ): null,
            Icons.add_rounded: {
              'route': AppRoutes.games,
              'arguments': {'isAdd': true},
            },
            locale.translate('new_deck.toggle.save'): () {
              cubit.saveDeck();
              cubit.toggleEditMode();
            },
          }
        : {
            Icons.arrow_back_ios_new_rounded: '/back',
            Icons.ios_share_rounded: () => _toggleShare(context, cubit, locale),
            state.deck.deckName: null,
            Icons.play_arrow_rounded: AppRoutes.tracker,
            locale.translate('new_deck.toggle.edit'): () => cubit.toggleEditMode(),
          };
  }

  void _showDeleteDialog(
    BuildContext context,
    DeckManagerCubit cubit,
    AppLocalizations locale,
  ) {
    showCupertinoAlertCancel(
      context: context,
      title: locale.translate('new_deck.dialog.delete.title'),
      content: locale.translate('new_deck.dialog.delete.content'),
      onConfirm: () {
        cubit.toggleDelete();
        showSnackBar(
          context: context,
          content: locale.translate('new_deck.dialog.delete.success'),
        );
      },
    );
  }

  void _renameDeck(
    DeckManagerCubit cubit,
    TextEditingController controller,
    AppLocalizations locale,
    String value,
  ) {
    final newName = value.trim().isNotEmpty
        ? value.trim()
        : locale.translate('new_deck.title');
    cubit.renameDeck(newName);
    controller.text = newName;
  }

  void _toggleShare(BuildContext context, DeckManagerCubit cubit, AppLocalizations locale) {
    cubit.toggleShare();
    showSnackBar(
      context: context,
      content: locale.translate('new_deck.dialog.share'),
    );
  }

  Widget _buildGridView(BuildContext context, DeckManagerCubit cubit) {
    final deckCards = cubit.state.deck.cards;

    return GridWidget(items: deckCards.entries.toList());
  }
}
