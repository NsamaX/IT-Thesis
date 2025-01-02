import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nfc_project/core/locales/localizations.dart';

Future<void> showSnackBar({
  required BuildContext context,
  required String content,
  bool? isError = false,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 1),
      backgroundColor: isError ?? false 
          ? CupertinoColors.systemRed
          : CupertinoColors.systemGreen,
    ),
  );
  await Future.delayed(const Duration(seconds: 1));
}

void showCupertinoAlertCancel({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
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

void showCupertinoAlertOK({
  required BuildContext context,
  required String title,
  required String content,
}) {
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
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}
