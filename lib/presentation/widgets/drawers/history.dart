import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../labels/card.dart';

class HistoryDrawerWidget extends StatelessWidget {
  final List<CardEntity> cards;

  const HistoryDrawerWidget({Key? key, required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reversedTags = cards.reversed.toList();
    return Container(
      width: 200,
      height: MediaQuery.of(context).size.height,
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
        itemCount: reversedTags.length,
        itemBuilder: (context, index) {
          return CardLabelWidget(
            card: reversedTags[index],
            lightTheme: true,
          );
        },
      ),
    );
  }
}
