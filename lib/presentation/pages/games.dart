import 'package:flutter/material.dart';
import 'package:nfc_project/core/constants/api_config.dart';
import 'package:nfc_project/core/constants/images.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import '../widgets/labels/games.dart';
import '../widgets/app_bar.dart';

class GamesPage extends StatelessWidget {
  //---------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final gameKeys = AppImages.game.keys.toList();
    final gameImages = AppImages.game.values.toList();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isAdd = arguments?['isAdd'] ?? false;

    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
      body: _buildGameList(gameKeys, gameImages, isAdd),
    );
  }

  //--------------------------------- App Bar --------------------------------//
  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) {
    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      locale.translate('title.games'): null,
      null: null,
    };
  }

  //--------------------------------- Widget ---------------------------------//
  Widget _buildGameList(List<String> gameKeys, List<String> gameImages, bool isAdd) {
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
