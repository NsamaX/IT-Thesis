import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import '../../blocs/NFC.dart';
import '../../blocs/deck_manager.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/card/card.dart';

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
        if (state.savedTags == null || state.savedTags!.isEmpty) {
          return _buildEmptyState(context);
        }
        final cards = context
            .read<DeckManagerCubit>()
            .state
            .allDecks
            .expand((deck) => deck.cards.keys)
            .toSet()
            .toList();
        return _buildCardGrid(cards);
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

  Widget _buildCardGrid(List<dynamic> savedCards) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: savedCards.length,
      itemBuilder: (context, index) {
        final card = savedCards[index];
        return CardWidget(card: card);
      },
    );
  }
}
