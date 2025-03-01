import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/domain/entities/card.dart';

import '../../cubits/deck_management/cubit.dart';

Widget buildEditControls(BuildContext context, CardEntity card, int count) {
  const double buttonSize = 24.0;
  const double spacing = 12.0;
  return Positioned(
    top: 0.0,
    right: 0.0,
    child: Column(
      children: [
        _CircleIndicator(
          content: count.toString(),
          size: buttonSize,
        ),
        const SizedBox(height: spacing),
        _OperatorButton(
          onPressed: () => context.read<DeckManagerCubit>().addCard(card, 1),
          icon: Icons.add,
          size: buttonSize,
        ),
        const SizedBox(height: spacing),
        _OperatorButton(
          onPressed: () => context.read<DeckManagerCubit>().removeCard(card),
          icon: Icons.remove,
          size: buttonSize,
        ),
      ],
    ),
  );
}

class _CircleIndicator extends StatelessWidget {
  final String content;
  final double size;

  const _CircleIndicator({
    Key? key,
    required this.content,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          content,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _OperatorButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double size;

  const _OperatorButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
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
          color: theme.primaryColor,
        ),
      ),
    );
  }
}
