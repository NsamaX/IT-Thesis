import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../label/card.dart';

class HistoryDrawerWidget extends StatelessWidget {
  final List<CardEntity> savedTags;

  const HistoryDrawerWidget({
    Key? key,
    required this.savedTags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reversedTags = savedTags.reversed.toList();
    return Container(
      width: 200,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: reversedTags.length,
        itemBuilder: (context, index) {
          final card = reversedTags[index];
          return CardLabelWidget(
            card: card,
            lightTheme: true,
          );
        },
      ),
    );
  }
}
