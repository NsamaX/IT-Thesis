import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/route.dart';
import '../../../domain/entities/deck.dart';
import '../../blocs/deck_manager.dart';

class DeckWidget extends StatelessWidget {
  final DeckEntity deck;

  const DeckWidget({
    Key? key,
    required this.deck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            context.read<DeckManagerCubit>().setDeck(deck);
            Navigator.of(context).pushNamed(AppRoutes.newDeck);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).appBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: Offset(3, 4),
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
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        if (context.watch<DeckManagerCubit>().state.isEditMode)
          Positioned(
            top: -2,
            right: -2,
            child: GestureDetector(
              onTap: () {
                context.read<DeckManagerCubit>().deleteDeck();
              },
              child: Container(
                width: 30,
                height: 30,
                child: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).secondaryHeaderColor,
                  size: 26,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
