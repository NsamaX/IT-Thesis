import 'package:flutter/material.dart';
import '../../../core/constants/image.dart';
import '../../../core/locales/localizations.dart';
import '../../../data/datasources/remote/api_config.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/label/supported_game.dart';

class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameKeys = AppImages.game.keys.toList();
    final gameImages = AppImages.game.values.toList();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isAdd = arguments?['isAdd'] ?? false;
    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.arrow_back_ios_new_rounded: '/back',
          AppLocalizations.of(context).translate('other.title'): null,
          null: null,
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView.builder(
          itemCount: gameKeys.length - 1,
          itemBuilder: (context, index) {
            return SupportedGameLabelWidget(
              game: gameKeys[index + 1],
              description: ApiConfig.baseUrls?[gameKeys[index + 1]] ?? '',
              imagePath: gameImages[index + 1],
              isAdd: isAdd,
            );
          },
        ),
      ),
    );
  }
}
