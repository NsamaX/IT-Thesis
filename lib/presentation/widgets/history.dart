import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'labels/setting.dart';

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return SettingLabelWidget(
      label: [
        {
          'title': locale.translate('settings.account.label'),
          'content': [
            {
              'onTap': () {},
              'text': 'date',
              'info': 'time',
              'arrow': true,
            },
          ],
        },
      ],
    );
  }
}
