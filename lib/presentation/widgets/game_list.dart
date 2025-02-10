import 'package:flutter/material.dart';
import 'package:nfc_project/core/constants/api_config.dart';
import 'package:nfc_project/core/locales/localizations.dart';
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
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: gameKeys.isEmpty
          ? Container()
          : ListView.builder(
              itemCount: gameKeys.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GameLabelWidget(
                    game: locale.translate('text.my_collection'),
                    description: locale.translate('text.collection_description'),
                    isAdd: isAdd,
                    isCustom: true,
                  );
                }
                final actualIndex = index - 1;
                final description = ApiConfig.baseUrls?[gameKeys[actualIndex]] ?? '';
                return GameLabelWidget(
                  game: gameKeys[actualIndex],
                  imagePath: gameImages[actualIndex],
                  description: description,
                  isAdd: isAdd,
                );
              },
            ),
    );
  }
}
