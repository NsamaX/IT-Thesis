import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../../cubits/deck_manager.dart';

Widget buildEditControls(
  BuildContext context,
  ThemeData theme,
  CardEntity card,
  int? count,
) {
  return Positioned(
    top: 0,
    right: 0,
    child: Column(
      children: [
        _buildCount(theme, count ?? 0),
        SizedBox(height: 6),
        _buildButton(
          theme,
          Icons.add,
          () => context.read<DeckManagerCubit>().addCard(card),
        ),
        SizedBox(height: 6),
        _buildButton(
          theme,
          Icons.remove,
          () => context.read<DeckManagerCubit>().removeCard(card),
        ),
      ],
    ),
  );
}

Widget _buildCount(ThemeData theme, int count) {
  return Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: theme.appBarTheme.backgroundColor,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        count.toString(),
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget _buildButton(ThemeData theme, IconData icon, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.only(top: 6),
    child: GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: theme.appBarTheme.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
      ),
    ),
  );
}
