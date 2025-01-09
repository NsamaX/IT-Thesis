import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../../cubits/deck_manager.dart';

Widget buildEditControls({
  required BuildContext context,
  required CardEntity card,
  required int? count,
}) {
  const double buttonSize = 24;

  return Positioned(
    top: 0,
    right: 0,
    child: Column(
      children: [
        _buildCount(context, count ?? 0, buttonSize),
        const SizedBox(height: 6),
        _buildButton(
          context,
          icon: Icons.add,
          onPressed: () => context.read<DeckManagerCubit>().addCard(card, 1),
          size: buttonSize,
        ),
        const SizedBox(height: 6),
        _buildButton(
          context,
          icon: Icons.remove,
          onPressed: () => context.read<DeckManagerCubit>().removeCard(card),
          size: buttonSize,
        ),
      ],
    ),
  );
}

Widget _buildCount(BuildContext context, int count, double size) {
  final theme = Theme.of(context);

  return Container(
    width: size,
    height: size,
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

Widget _buildButton(BuildContext context, {
  required IconData icon,
  required VoidCallback onPressed,
  required double size,
}) {
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.only(top: 6),
    child: GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: theme.appBarTheme.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: size / 1.5,
          color: theme.colorScheme.primary,
        ),
      ),
    ),
  );
}
