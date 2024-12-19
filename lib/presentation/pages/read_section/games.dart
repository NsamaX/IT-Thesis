import 'package:flutter/material.dart';
import 'package:nfc_project/core/constants/api_config.dart';
import 'package:nfc_project/core/constants/images.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import '../../widgets/label/supported_game.dart';
import '../../widgets/navigation_bar/app.dart';

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final gameKeys = AppImages.game.keys.toList();
    final gameImages = AppImages.game.values.toList();
    final isAdd = _extractIsAddArgument(context);

    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
      body: _buildGameList(gameKeys, gameImages, isAdd),
    );
  }

  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) {
    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      locale.translate('games.title'): null,
      null: null,
    };
  }

  bool _extractIsAddArgument(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return arguments?['isAdd'] ?? false;
  }

  Widget _buildGameList(List<String> gameKeys, List<String> gameImages, bool isAdd) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        itemCount: gameKeys.length,
        itemBuilder: (context, index) {
          return SupportedGameLabelWidget(
            game: gameKeys[index],
            description: ApiConfig.baseUrls?[gameKeys[index]] ?? '',
            imagePath: gameImages[index],
            isAdd: isAdd,
          );
        },
      ),
    );
  }
}
