import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nfc_project/core/locales/localizations.dart';

Future<void> snackBar({
  required BuildContext context,
  required String content,
  bool isError = false,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: isError
          ? CupertinoColors.systemRed
          : CupertinoColors.systemGreen,
    ),
  );
  await Future.delayed(const Duration(seconds: 1));
}

void cupertinoAlertDialog({
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
    barrierColor: Colors.black.withOpacity(0.5),
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
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              locale.translate('button.ok'),
              style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.systemBlue),
            ),
          ),
        ],
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

void cupertinoAlertDialogAction({
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
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              locale.translate('button.cancel'),
              style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.systemRed),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(
              locale.translate('button.confirm'),
              style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.systemBlue),
            ),
          ),
        ],
      );
    },
  );
}
