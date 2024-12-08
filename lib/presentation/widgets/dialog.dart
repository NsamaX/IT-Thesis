import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nfc_project/core/locales/localizations.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: Duration(seconds: 2),
      backgroundColor: CupertinoColors.systemGreen,
    ),
  );
}

void showCupertinoAlertCancle(BuildContext context, String title, String content, VoidCallback onConfirm) {
  final locale = AppLocalizations.of(context);
  final theme = Theme.of(context);
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.black),
        ),
        content: Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.black),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              locale.translate('dialog.cancel'),
              style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.systemRed),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: Text(
              locale.translate('dialog.confirm'),
              style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.systemBlue),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
        ],
      );
    },
  );
}

void showCupertinoAlertOK(BuildContext context, String title, String content) {
  final locale = AppLocalizations.of(context);
  final theme = Theme.of(context);
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    pageBuilder: (context, animation1, animation2) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.black),
        ),
        content: Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.black),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              locale.translate('dialog.ok'),
              style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.systemBlue),
            ),
            onPressed: () => Navigator.of(context).pop()
          ),
        ],
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}
