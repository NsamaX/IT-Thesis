import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../labels/card.dart';

class HistoryDrawerWidget extends StatelessWidget {
  final List<CardEntity> savedTags;

  const HistoryDrawerWidget({Key? key, required this.savedTags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reversedTags = savedTags.reversed.toList();

    return Container(
      width: 200,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 2),
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
