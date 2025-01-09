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
      onTap: () {
        context.read<DeckManagerCubit>().setDeck(deck);
        Navigator.of(context).pushNamed(AppRoutes.newDeck);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: theme.appBarTheme.backgroundColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(3.0, 4.0),
              blurRadius: 6.0,
              spreadRadius: 0.0,
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

  Widget _buildDeleteButton(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      top: -2.0,
      right: -2.0,
      child: GestureDetector(
        onTap: () => context.read<DeckManagerCubit>().deleteDeck(deck),
        child: Container(
          width: 30.0,
          height: 30.0,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close_rounded,
            color: theme.colorScheme.primary,
            size: 26.0,
          ),
        ),
      ),
    );
  }
}
