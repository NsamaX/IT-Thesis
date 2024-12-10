import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import '../../blocs/deck_manager.dart';
import '../../blocs/NFC.dart';
import '../../widgets/card/grid.dart';
import '../../widgets/navigation_bar/app.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
      body: _buildBody(context),
    );
  }

  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) {
    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      locale.translate('library.title'): null,
      null: null,
    };
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<NFCCubit, NFCState>(
      builder: (context, state) {
        final cards = context
            .read<DeckManagerCubit>()
            .state
            .allDecks
            .expand((deck) => deck.cards.keys)
            .toSet()
            .toList();
        return cards.isNotEmpty
            ? GridWidget(items: cards)
            : _buildEmptyState(context);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final locale = AppLocalizations.of(context);
    
    return Center(
      child: Text(
        locale.translate('library.empty'),
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
