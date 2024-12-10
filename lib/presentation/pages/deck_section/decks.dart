import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import '../../blocs/deck_manager.dart';
import '../../widgets/card/deck.dart';
import '../../widgets/navigation_bar/app.dart';
import '../../widgets/navigation_bar/bottom.dart';

class DecksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<DeckManagerCubit>();

    cubit.loadDecks();

    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(context, cubit, locale)),
      body: _buildBody(context),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }

  Map<dynamic, dynamic> _buildAppBarMenu(
    BuildContext context,
    DeckManagerCubit cubit,
    AppLocalizations locale,
  ) {
    final state = context.watch<DeckManagerCubit>().state;

    return {
      Icons.open_in_new_rounded: () => _createNewDeck(context, cubit, locale),
      locale.translate('decks.title'): null,
      state.allDecks.isNotEmpty ? Icons.edit_rounded : null: cubit.toggleEditMode,
    };
  }

  void _createNewDeck(
    BuildContext context,
    DeckManagerCubit cubit,
    AppLocalizations locale,
  ) {
    cubit.setDeck(
      DeckEntity(
        deckId: const Uuid().v4(),
        deckName: locale.translate('builder.title'),
        cards: {},
      ),
    );

    if (context.read<DeckManagerCubit>().state.isEditMode) {
      cubit.toggleEditMode();
    }

    Navigator.of(context).pushNamed(AppRoutes.builder);
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<DeckManagerCubit, DeckManagerState>(
      builder: (context, state) {
        final decks = state.allDecks;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: decks.length,
            itemBuilder: (context, index) {
              final deck = decks[index];
              return DeckWidget(deck: deck);
            },
          ),
        );
      },
    );
  }
}
