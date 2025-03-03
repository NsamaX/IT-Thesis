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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: gameKeys.isEmpty ? Container() : _buildGameList(context),
    );
  }

  /// Create a list of all games
  Widget _buildGameList(BuildContext context) {
    return ListView.builder(
      itemCount: gameKeys.length + 1,
      itemBuilder: (context, index) {
        return index == 0 ? _buildGameLabel(context) : _buildGameItem(index - 1);
      },
    );
  }

  /// Game: "My Collection"
  Widget _buildGameLabel(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return GameLabelWidget(
      game: locale.translate('text.my_collection'),
      description: locale.translate('text.collection_description'),
      isAdd: isAdd,
      isCustom: true,
    );
  }

  /// Each game list
  Widget _buildGameItem(int index) {
    final description = ApiConfig.baseUrls[gameKeys[index]] ?? '';

    return GameLabelWidget(
      game: gameKeys[index],
      imagePath: gameImages[index],
      description: description,
      isAdd: isAdd,
    );
  }
}
