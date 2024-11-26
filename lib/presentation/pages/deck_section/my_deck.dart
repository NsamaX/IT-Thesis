import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../core/locales/localizations.dart';
import '../../../core/routes/route.dart';
import '../../../domain/entities/deck.dart';
import '../../blocs/bottom_nav.dart';
import '../../blocs/deck_manager.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/bar/bottom_navigation.dart';
import '../../widgets/card/deck.dart';

class MyDeckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<DeckManagerCubit>().loadDecks();
    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.open_in_new_rounded: () {
            context.read<DeckManagerCubit>().setDeck(
                  DeckEntity(
                    deckId: Uuid().v4(),
                    deckName: AppLocalizations.of(context)
                        .translate('new_deck.title'),
                    cards: {},
                  ),
                );
            if (context.read<DeckManagerCubit>().state.isEditMode) {
              context.read<DeckManagerCubit>().toggleEditMode();
            }
            Navigator.of(context).pushNamed(AppRoutes.newDeck);
          },
          AppLocalizations.of(context).translate('my_deck.title'): null,
          Icons.edit_rounded: context.read<DeckManagerCubit>().toggleEditMode,
        },
      ),
      bottomNavigationBar: BlocProvider(
        create: (context) => BottomNavCubit(0),
        child: BottomNavigationBarWidget(),
      ),
      body: BlocBuilder<DeckManagerCubit, DeckManagerState>(
        builder: (context, state) {
          final decks = state.allDecks;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      ),
    );
  }
}
