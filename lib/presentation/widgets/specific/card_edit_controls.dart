import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/domain/entities/card.dart';

import '../../cubits/deck_management/cubit.dart';

Widget buildEditControls(
  BuildContext context, 
  CardEntity card, 
  int count,
) {
  const double buttonSize = 24.0;
  const double spacing = 12.0;

  return Positioned(
    top: 0.0,
    right: 0.0,
    child: Column(
      children: [
        _circleIndicator(context, count.toString(), buttonSize),
        const SizedBox(height: spacing),
        _operatorButton(
          context,
          onPressed: () => context.read<DeckManagerCubit>().addCard(card, 1),
          icon: Icons.add,
          size: buttonSize,
        ),
        const SizedBox(height: spacing),
        _operatorButton(
          context,
          onPressed: () => context.read<DeckManagerCubit>().removeCard(card),
          icon: Icons.remove,
          size: buttonSize,
        ),
      ],
    ),
  );
}

Widget _circleIndicator(
  BuildContext context, 
  String content, 
  double size,
) {
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

Widget _operatorButton(
  BuildContext context, {
  required VoidCallback onPressed,
  required IconData icon,
  required double size,
}) {
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
