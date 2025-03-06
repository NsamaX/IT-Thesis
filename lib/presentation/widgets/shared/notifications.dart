import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:nfc_project/core/locales/localizations.dart';

const _snackBarDuration = Duration(seconds: 1);
const _dialogTransitionDuration = Duration(milliseconds: 200);

void snackBar(
  BuildContext context, 
  String content, 
  {
    bool isError = false,
  }
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: const TextStyle(color: Colors.white),
      ),
      duration: _snackBarDuration,
      backgroundColor: isError ? CupertinoColors.destructiveRed : CupertinoColors.activeGreen,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void cupertinoAlertDialog(
  BuildContext context, 
  String title, 
  String content,
) {
  final locale = AppLocalizations.of(context);

  _showDialog(
    context,
    title,
    content,
    [_buildDialogAction(locale.translate('button.ok'), () => Navigator.of(context).pop(), CupertinoColors.activeBlue)],
  );
}

void cupertinoAlertDialogAction(
  BuildContext context,
  String title,
  String content,
  VoidCallback onConfirm,
) {
  final locale = AppLocalizations.of(context);

  _showDialog(
    context,
    title,
    content,
    [
      _buildDialogAction(locale.translate('button.cancel'), () => Navigator.of(context).pop(), CupertinoColors.destructiveRed),
      _buildDialogAction(locale.translate('button.confirm'), () {
        Navigator.of(context).pop();
        onConfirm();
      }, CupertinoColors.activeBlue),
    ],
  );
}

void cupertinoMultipleChoicesDialog(
  BuildContext context,
  String title,
  String content,
  Map<String, Map<String, dynamic>> choices,
) {
  _showDialog(
    context,
    title,
    content,
    choices.entries.map((entry) {
      final isCancel = entry.value['isCancel'] ?? false;
      final callback = entry.value['onPressed'] as VoidCallback;

      return _buildDialogAction(
        entry.key,
        callback,
        isCancel ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue,
      );
    }).toList(),
  );
}

void _showDialog(
  BuildContext context, 
  String title, 
  String content, 
  List<Widget> actions,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withAlpha((0.2 * 255).toInt()),
    transitionDuration: _dialogTransitionDuration,
    pageBuilder: (_, __, ___) => CupertinoAlertDialog(
      title: _buildDialogTitleText(title),
      content: _buildDialogContentText(content),
      actions: actions,
    ),
  );
}

Widget _buildDialogTitleText(
  String text,
) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _buildDialogContentText(
  String text,
) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w100,
    ),
  );
}

Widget _buildDialogAction(
  String label, 
  VoidCallback onPressed, 
  Color color,
) {
  return CupertinoDialogAction(
    onPressed: onPressed,
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w100,
      ),
    ),
  );
}
