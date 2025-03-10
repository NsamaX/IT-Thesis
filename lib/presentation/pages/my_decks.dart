import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import '../cubits/deck_management/cubit.dart';

import '../widgets/shared/app_bar.dart';
import '../widgets/shared/bottom_navigation_bar.dart';
import '../widgets/shared/deck_card_grid.dart';

import 'features/my_decks.dart';

class MyDecksPage extends StatefulWidget {
  @override
  State<MyDecksPage> createState() => _MyDecksPageState();
}

class _MyDecksPageState extends State<MyDecksPage> {
  late final DeckManagerCubit _DeckManagerCubit;

  /*-------------------------------- Lifecycle -------------------------------*/
  @override
  void initState() {
    super.initState();
    _DeckManagerCubit = context.read<DeckManagerCubit>();
    if(_DeckManagerCubit.state.isEditModeEnabled) {
      _DeckManagerCubit.toggleEditMode();
    }
  }

  /*---------------------------------- Build ---------------------------------*/
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

  /*--------------------------------- App Bar --------------------------------*/
  Map<dynamic, dynamic> _buildAppBarMenu(BuildContext context, DeckManagerCubit cubit, AppLocalizations locale) {
    final state = context.watch<DeckManagerCubit>().state;
    return {
      Icons.open_in_new_rounded: () => createNewDeck(context, cubit, locale),
      locale.translate('title.my_decks'): null,
      state.decks.isNotEmpty ? Icons.edit_rounded : null: cubit.toggleEditMode,
    };
  }

  /*---------------------------------- Body ----------------------------------*/
  Widget _buildBody(BuildContext context) => BlocBuilder<DeckManagerCubit, DeckManagerState>(
    builder: (context, state) {
      final decks = state.decks;
      return DeckCardGridWidget(items: decks);
    },
  );
}
