import 'package:flutter/material.dart';
import '../../core/locales/localizations.dart';
import '../../core/routes/route.dart';
import '../widgets/app_bar.dart';

class NewDeckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        menu: true
            // ignore: dead_code
            ? {
                Icons.window_rounded: '/back',
                Icons.upload_rounded: null,
                AppLocalizations.of(context).translate('new_deck_title'): null,
                Icons.play_arrow_rounded: AppRoutes.track,
                Icons.build_outlined: null,
              }
            // ignore: dead_code
            : {
                Icons.nfc_rounded: null,
                Icons.delete_rounded: null,
                AppLocalizations.of(context).translate('new_deck_title'): null,
                Icons.search_rounded: null,
                Icons.build_outlined: null,
              },
      ),
    );
  }
}
