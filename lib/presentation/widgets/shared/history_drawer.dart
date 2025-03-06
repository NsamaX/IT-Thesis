import 'package:flutter/material.dart';

import 'package:nfc_project/domain/entities/card.dart';

import '../specific/card_label.dart';

class HistoryDrawerWidget extends StatelessWidget {
  final List<CardEntity> cards;
  final double height;
  final bool isNFC;

  const HistoryDrawerWidget({
    super.key,
    required this.cards,
    required this.height,
    this.isNFC = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<CardEntity> reversedCards = List.from(cards.reversed);

    return Container(
      width: 200,
      height: height,
      decoration: _buildBoxDecoration(),
      child: ListView.builder(
        itemCount: reversedCards.length,
        itemBuilder: (context, index) => CardLabelWidget(
          card: reversedCards[index],
          isNFC: isNFC,
          lightTheme: true,
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((0.2 * 255).toInt()),
          offset: const Offset(0, 3),
          blurRadius: 2,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
