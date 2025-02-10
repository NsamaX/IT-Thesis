import 'package:flutter/material.dart';
import 'package:nfc_project/core/constants/api_config.dart';
import 'labels/games.dart';

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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: gameKeys.isEmpty
        ? const Center(child: Text('No games available'))
        : ListView.builder(
            itemCount: gameKeys.length,
            itemBuilder: (context, index) {
              final description = ApiConfig.baseUrls?[gameKeys[index]] ?? '';
              return GamesLabelWidget(
                game: gameKeys[index],
                imagePath: gameImages[index],
                description: description,
                isAdd: isAdd,
              );
            },
          ),
  );
}
