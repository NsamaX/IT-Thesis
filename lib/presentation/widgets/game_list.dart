import 'package:flutter/material.dart';
import 'package:nfc_project/core/constants/api_config.dart';
import 'labels/game.dart';

class GameListWidget extends StatelessWidget {
  final List<String> gameKeys;
  final List<String> gameImages;
  final bool isAdd;

  const GameListWidget({
    Key? key,
    required this.gameKeys,
    required this.gameImages,
    this.isAdd = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: gameKeys.isEmpty
        ? Container()
        : ListView.builder(
            itemCount: gameKeys.length,
            itemBuilder: (context, index) {
              final description = ApiConfig.baseUrls?[gameKeys[index]] ?? '';
              return GameLabelWidget(
                game: gameKeys[index],
                imagePath: gameImages[index],
                description: description,
                isAdd: isAdd,
              );
            },
          ),
  );
}
