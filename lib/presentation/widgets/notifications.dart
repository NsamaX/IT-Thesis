import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:nfc_project/core/locales/localizations.dart';

const _snackBarDuration = Duration(seconds: 1);
const _dialogTransitionDuration = Duration(milliseconds: 200);

/// Displays a Snackbar notification
Future<void> snackBar(BuildContext context, String content, {bool isError = false}) async {
  return Future.delayed(
    _snackBarDuration,
    () => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content, style: const TextStyle(color: Colors.white)),
        duration: _snackBarDuration,
        backgroundColor: isError 
            ? CupertinoColors.destructiveRed 
            : CupertinoColors.activeGreen,
        behavior: SnackBarBehavior.floating,
      ),
    ),
  );
}

/// Displays a Cupertino Alert Dialog with a single "OK" button
void cupertinoAlertDialog(BuildContext context, String title, String content) {
  final locale = AppLocalizations.of(context);

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => CupertinoAlertDialog(
      title: _buildDialogTitleText(title),
      content: _buildDialogContentText(content),
      actions: [
        _buildDialogAction(
          locale.translate('button.ok'),
          () => Navigator.of(context).pop(),
          CupertinoColors.activeBlue,
        ),
      ],
    ),
    transitionDuration: _dialogTransitionDuration,
  );
}

/// Displays a Cupertino Alert Dialog with "Cancel" and "Confirm" buttons
void cupertinoAlertDialogAction(BuildContext context, String title, String content, VoidCallback onConfirm) {
  final locale = AppLocalizations.of(context);

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => CupertinoAlertDialog(
      title: _buildDialogTitleText(title),
      content: _buildDialogContentText(content),
      actions: [
        _buildDialogAction(
          locale.translate('button.cancel'),
          () => Navigator.of(context).pop(),
          CupertinoColors.destructiveRed,
        ),
        _buildDialogAction(
          locale.translate('button.confirm'),
          () {
            Navigator.of(context).pop();
            onConfirm();
          },
          CupertinoColors.activeBlue,
        ),
      ],
    ),
  );
}

/// Displays a Cupertino Alert Dialog with multiple choices
void cupertinoMultipleChoicesDialog(
  BuildContext context,
  String title,
  String content,
  Map<String, Map<String, dynamic>> choices,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withAlpha((0.2 * 255).toInt()),
    pageBuilder: (context, animation1, animation2) => CupertinoAlertDialog(
      title: _buildDialogTitleText(title),
      content: _buildDialogContentText(content),
      actions: choices.entries.map((entry) {
        final isCancel = entry.value['isCancel'] ?? false;
        final callback = entry.value['onPressed'] as VoidCallback;
        return _buildDialogAction(
          entry.key,
          callback,
          isCancel ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue,
        );
      }).toList(),
    ),
  );
}

/// Helper to create dialog title text
Widget _buildDialogTitleText(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
  );
}

/// Helper to create dialog content text
Widget _buildDialogContentText(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w100,
    ),
  );
}

/// Helper to create dialog action buttons
Widget _buildDialogAction(String label, VoidCallback onPressed, Color color) {
  return CupertinoDialogAction(
    onPressed: onPressed,
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 12.0,
        fontWeight: FontWeight.w100,
      ),
    ),
  );
}
