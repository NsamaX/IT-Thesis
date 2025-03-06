import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import '../cubits/deck_management/cubit.dart';
import '../cubits/NFC/cubit.dart';

import '../widgets/deck/deck_card_grid.dart';

import '../widgets/shared/app_bar.dart';

class LibraryPage extends StatelessWidget {
  //---------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
      body: _buildBody(context),
    );
  }

  //--------------------------------- App Bar --------------------------------//
  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) => {
    Icons.arrow_back_ios_new_rounded: '/back',
    locale.translate('title.library'): null,
    null: null,
  };

  //--------------------------------- Body ---------------------------------//
  Widget _buildBody(BuildContext context) => BlocBuilder<NFCCubit, NFCState>(
    builder: (context, state) {
      final cards = context
          .read<DeckManagerCubit>()
          .state
          .decks
          .expand((deck) => deck.cards.keys)
          .toSet()
          .toList();
      return DeckCardGridWidget(items: cards);
    },
  );
}
