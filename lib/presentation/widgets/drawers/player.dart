import 'package:flutter/material.dart';

class PlayerDrawerWidget extends StatelessWidget {
  const PlayerDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 160,
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
    );
  }
}
