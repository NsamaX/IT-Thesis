import 'package:flutter/material.dart';

import 'package:nfc_project/core/constants/images.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/data/datasources/remote/api_config.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/label/supported_game.dart';

class HubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameKeys = AppImages.game.keys.toList();
    final gameImages = AppImages.game.values.toList();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isAdd = arguments?['isAdd'] ?? false;
    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.arrow_back_ios_new_rounded: '/back',
          AppLocalizations.of(context).translate('hub.title'): null,
          null: null,
        },
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
      ),
    );
  }
}
