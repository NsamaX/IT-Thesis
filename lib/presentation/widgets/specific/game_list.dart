import 'package:flutter/material.dart';

import 'package:nfc_project/core/constants/api_config.dart';
import 'package:nfc_project/core/locales/localizations.dart';

import 'game_label.dart';

class GameListWidget extends StatelessWidget {
  final List<String> gameKeys;
  final List<String> gameImages;
  final bool isAdd;

  const GameListWidget({
    super.key,
    required this.gameKeys,
    required this.gameImages,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    if (gameKeys.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: _buildGameList(context),
    );
  }

  Widget _buildGameList(
    BuildContext context,
  ) {
    return ListView.separated(
      itemCount: gameKeys.length + 1,
      itemBuilder: (context, index) => index == 0 ? _buildGameLabel(context) : _buildGameItem(index - 1),
      separatorBuilder: (_, __) => const SizedBox(height: 2.0),
    );
  }

  Widget _buildGameLabel(
    BuildContext context,
  ) {
    final locale = AppLocalizations.of(context);

    return GameLabelWidget(
      game: locale.translate('text.my_collection'),
      description: locale.translate('text.collection_description'),
      isAdd: isAdd,
      isCustom: true,
    );
  }

  Widget _buildGameItem(
    int index,
  ) {
    return GameLabelWidget(
      game: gameKeys[index],
      imagePath: gameImages[index],
      description: ApiConfig.baseUrls[gameKeys[index]] ?? '',
      isAdd: isAdd,
    );
  }
}
