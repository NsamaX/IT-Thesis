import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import '../../blocs/deck_manager.dart';

class DeckWidget extends StatelessWidget {
  final DeckEntity deck;

  const DeckWidget({
    Key? key,
    required this.deck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditMode = context.watch<DeckManagerCubit>().state.isEditMode;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildDeckContainer(context, theme),
        if (isEditMode) _buildDeleteButton(context, theme),
      ],
    );
  }

  Widget _buildDeckContainer(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () => _navigateToDeckBuilder(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.appBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(3, 4),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
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

  Widget _buildDeleteButton(BuildContext context, ThemeData theme) {
    return Positioned(
      top: -2,
      right: -2,
      child: GestureDetector(
        onTap: () => context.read<DeckManagerCubit>().deleteDeck(),
        child: Container(
          width: 30,
          height: 30,
          child: Icon(
            Icons.close_rounded,
            color: theme.secondaryHeaderColor,
            size: 26,
          ),
        ),
      ),
    );
  }

  void _navigateToDeckBuilder(BuildContext context) {
    context.read<DeckManagerCubit>().setDeck(deck);
    Navigator.of(context).pushNamed(AppRoutes.builder);
  }
}
