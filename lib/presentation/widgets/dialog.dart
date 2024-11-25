import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/locales/localizations.dart';

void showSnackBar(
  BuildContext context,
  String content,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ),
  );
}

void showCupertinoAlertCancle(
  BuildContext context,
  String title,
  String content,
  VoidCallback onConfirm,
) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        content: Text(
          content,
          style: CupertinoTheme.of(context).textTheme.textStyle,
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              AppLocalizations.of(context).translate('dialog.cancel'),
              style: TextStyle(color: CupertinoColors.systemRed),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              return;
            },
          ),
          CupertinoDialogAction(
            child: Text(
              AppLocalizations.of(context).translate('dialog.confirm'),
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

void showCupertinoAlertOK(
  BuildContext context,
  String title,
  String content,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    pageBuilder: (context, animation1, animation2) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        content: Text(
          content,
          style: CupertinoTheme.of(context).textTheme.textStyle,
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              AppLocalizations.of(context).translate('dialog.ok'),
              style: TextStyle(color: CupertinoColors.systemBlue),
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
