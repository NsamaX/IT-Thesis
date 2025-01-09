import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import '../cubits/deck_manager.dart';

class DeckWidget extends StatelessWidget {
  final DeckEntity deck;

  const DeckWidget({
    Key? key,
    required this.deck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildDeckContainer(context),
        if (context.watch<DeckManagerCubit>().state.isEditMode) _buildDeleteButton(context),
      ],
    );
  }

  Widget _buildDeckContainer(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _navigateToDeckBuilder(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.appBarTheme.backgroundColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(3, 4),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              deck.deckName,
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDeckBuilder(BuildContext context) {
    context.read<DeckManagerCubit>().setDeck(deck);
    Navigator.of(context).pushNamed(AppRoutes.newDeck);
  }

  Widget _buildDeleteButton(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      top: -2,
      right: -2,
      child: GestureDetector(
        onTap: () => context.read<DeckManagerCubit>().deleteDeck(deck),
        child: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.close_rounded,
            color: theme.colorScheme.primary,
            size: 26,
          ),
        ),
      ),
    );
  }
}
