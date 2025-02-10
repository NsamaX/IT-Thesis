import 'package:flutter/material.dart';
import 'package:nfc_project/core/constants/images.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/utils/arguments.dart';
import '../widgets/app_bar.dart';
import '../widgets/game_list.dart';

class GamePage extends StatelessWidget {
  //---------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final gameKeys = AppImages.game.keys.toList();
    final gameImages = AppImages.game.values.toList();
    final arguments = getArguments(context);
    final isAdd = arguments['isAdd'] ?? false;
    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
      body: GameListWidget(
        gameKeys: gameKeys,
        gameImages: gameImages,
        isAdd: isAdd,
      ),
    );
  }

  //--------------------------------- App Bar --------------------------------//
  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) => {
    Icons.arrow_back_ios_new_rounded: '/back',
    locale.translate('title.games'): null,
    null: null,
  };
}
