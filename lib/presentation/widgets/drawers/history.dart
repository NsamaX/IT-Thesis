import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../labels/card.dart';

class HistoryDrawerWidget extends StatelessWidget {
  final List<CardEntity> cards;
  final double height;
  final bool isNFC;

  const HistoryDrawerWidget({
    Key? key,
    required this.cards,
    required this.height,
    this.isNFC = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reversedCards = cards.reversed.toList();
    return Container(
      width: 200,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0.0, 3.0),
            blurRadius: 2.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
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
}
