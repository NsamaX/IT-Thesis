import 'package:flutter/material.dart';
import '../widgets/labels/games.dart';
import 'package:nfc_project/core/constants/api_config.dart';

class GamesListWidget extends StatelessWidget {
  final List<String> gameKeys;
  final List<String> gameImages;
  final bool isAdd;

  const GamesListWidget({
    Key? key,
    required this.gameKeys,
    required this.gameImages,
    this.isAdd = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        itemCount: gameKeys.length,
        itemBuilder: (context, index) {
          return GamesLabelWidget(
            game: gameKeys[index],
            imagePath: gameImages[index],
            description: ApiConfig.baseUrls?[gameKeys[index]] ?? '',
            isAdd: isAdd,
          );
        },
      ),
    );
  }
}
