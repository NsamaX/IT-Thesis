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

class MyDeckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.open_in_new_rounded: () {
            context.read<DeckMangerCubit>().setDeck(
                  DeckEntity(
                    deckId: Uuid().v4(),
                    deckName: AppLocalizations.of(context)
                        .translate('new_deck.title'),
                    cards: {},
                  ),
                );
            Navigator.of(context).pushNamed(AppRoutes.newDeck);
          },
          AppLocalizations.of(context).translate('my_deck.title'): null,
          Icons.edit_rounded: null,
        },
      ),
      bottomNavigationBar: BlocProvider(
        create: (context) => BottomNavCubit(0),
        child: BottomNavigationBarWidget(),
      ),
    );
  }
}
