import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/locales/localizations.dart';

String translate(BuildContext context, String key) {
  try {
    return AppLocalizations.of(context).translate(key);
  } catch (e) {
    return key;
  }
}

void showiOSPopup(BuildContext context) {
  final theme = Theme.of(context);
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    pageBuilder: (context, animation1, animation2) {
      return CupertinoAlertDialog(
        title: Text(
          translate(context, 'dialog_tracker_title'),
          style: theme.textTheme.titleSmall?.copyWith(color: Colors.black),
        ),
        content: Text(
          translate(context, 'dialog_tracker_content'),
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.black),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              translate(context, 'dialog_tracker_button'),
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.blue[800],
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}
