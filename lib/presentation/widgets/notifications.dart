import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nfc_project/core/locales/localizations.dart';

const _snackBarDuration = Duration(seconds: 1);
const _dialogTransitionDuration = Duration(milliseconds: 200);

Future<void> snackBar(BuildContext context, String content, {bool isError = false}) async =>
    Future.delayed(
      _snackBarDuration,
      () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(content, style: const TextStyle(color: Colors.white)),
          duration: _snackBarDuration,
          backgroundColor: isError 
              ? CupertinoColors.destructiveRed 
              : CupertinoColors.activeGreen,
        ),
      ),
    );

void cupertinoAlertDialog(BuildContext context, String title, String content) {
  final locale = AppLocalizations.of(context);
  final theme = Theme.of(context);
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withAlpha((0.5 * 255).toInt()),
    pageBuilder: (context, animation1, animation2) => CupertinoAlertDialog(
      title: _buildDialogTitleText(theme, title),
      content: _buildDialogContentText(theme, content),
      actions: [
        _buildDialogAction(
          theme,
          locale.translate('button.ok'),
          () => Navigator.of(context).pop(),
          CupertinoColors.activeBlue,
        ),
      ],
    ),
    transitionDuration: _dialogTransitionDuration,
  );
}

void cupertinoAlertDialogAction(BuildContext context, String title, String content, VoidCallback onConfirm) {
  final locale = AppLocalizations.of(context);
  final theme = Theme.of(context);
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withAlpha((0.5 * 255).toInt()),
    pageBuilder: (context, animation1, animation2) => CupertinoAlertDialog(
      title: _buildDialogTitleText(theme, title),
      content: _buildDialogContentText(theme, content),
      actions: [
        _buildDialogAction(
          theme,
          locale.translate('button.cancel'),
          () => Navigator.of(context).pop(),
          CupertinoColors.destructiveRed,
        ),
        _buildDialogAction(
          theme,
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

void cupertinoMultipleChoicesDialog(
  BuildContext context,
  String title,
  String content,
  Map<String, Map<String, dynamic>> choices,
) {
  final theme = Theme.of(context);
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withAlpha((0.5 * 255).toInt()),
    pageBuilder: (context, animation1, animation2) => CupertinoAlertDialog(
      title: _buildDialogTitleText(theme, title),
      content: _buildDialogContentText(theme, content),
      actions: choices.entries.map((entry) {
        final isCancel = entry.value['isCancel'] ?? false;
        final callback = entry.value['onPressed'] as VoidCallback;
        return _buildDialogAction(
          theme,
          entry.key,
          callback,
          isCancel ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue,
        );
      }).toList(),
    ),
  );
}

Widget _buildDialogTitleText(ThemeData theme, String text) => Text(
  text,
  style: TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  ),
);

Widget _buildDialogContentText(ThemeData theme, String text) => Text(
  text,
  style: TextStyle(
    color: Colors.black,
    fontSize: 12.0,
    fontWeight: FontWeight.w100,
  ),
);

Widget _buildDialogAction(ThemeData theme, String label, VoidCallback onPressed, Color color) => CupertinoDialogAction(
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
