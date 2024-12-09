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
    final isEditMode = context.watch<DeckManagerCubit>().state.isEditMode;
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
                hintText: locale.translate('builder.title'),
              ),
              onSubmitted: (value) => _renameDeck(cubit, deckNameController, locale, value),
            ): null,
            Icons.add_rounded: {
              'route': AppRoutes.games,
              'arguments': {'isAdd': true},
            },
            locale.translate('builder.toggle.save'): () {
              cubit.saveDeck();
              cubit.toggleEditMode();
            },
          }
        : {
            Icons.arrow_back_ios_new_rounded: '/back',
            Icons.ios_share_rounded: () => _toggleShare(context, cubit, locale),
            cubit.state.deck.deckName: null,
            Icons.play_arrow_rounded: AppRoutes.tracker,
            locale.translate('builder.toggle.edit'): () => cubit.toggleEditMode(),
          };
  }

  void _showDeleteDialog(
    BuildContext context,
    DeckManagerCubit cubit,
    AppLocalizations locale,
  ) {
    showCupertinoAlertCancel(
      context: context,
      title: locale.translate('builder.dialog.delete.title'),
      content: locale.translate('builder.dialog.delete.content'),
      onConfirm: () {
        cubit.toggleDelete();
        showSnackBar(
          context: context,
          content: locale.translate('builder.dialog.delete.success'),
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
        : locale.translate('builder.title');
    cubit.renameDeck(newName);
    controller.text = newName;
  }

  void _toggleShare(
      BuildContext context, DeckManagerCubit cubit, AppLocalizations locale) {
    cubit.toggleShare();
    showSnackBar(
      context: context,
      content: locale.translate('builder.dialog.share'),
    );
  }

  Widget _buildGridView(BuildContext context, DeckManagerCubit cubit) {
    final deckCards = cubit.state.deck.cards;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: deckCards.length,
      itemBuilder: (context, index) {
        final card = deckCards.keys.toList()[index];
        final count = deckCards[card]!;
        return CardWidget(
          card: card,
          count: count,
        );
      },
    );
  }
}
