import 'package:flutter/material.dart';
import '../label/card.dart';

class HistoryDrawerWidget extends StatelessWidget {
  const HistoryDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        itemCount: 20,
        itemBuilder: (context, index) {
          return CardLabelWidget(card: null, lightTheme: true);
        },
      ),
    );
  }
}
