import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nfc_project/core/locales/localizations.dart';

const _snackBarDuration = Duration(seconds: 1);
const _dialogTransitionDuration = Duration(milliseconds: 200);

const _successColor = CupertinoColors.systemGreen;
const _errorColor = CupertinoColors.systemRed;

Future<void> snackBar(BuildContext context, String content, {bool isError = false}) async => Future.delayed(
  _snackBarDuration,
  () => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content, style: const TextStyle(color: Colors.white)),
      duration: _snackBarDuration,
      backgroundColor: isError ? _errorColor : _successColor,
    ),
  ),
);

void cupertinoAlertDialog(BuildContext context, String title, String content) {
  final locale = AppLocalizations.of(context);
  final theme = Theme.of(context);
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => CupertinoAlertDialog(
      title: _buildDialogTitleText(theme, title),
      content: _buildDialogContentText(theme, content),
      actions: [
        _buildDialogAction(
          theme,
          locale.translate('button.ok'),
          () => Navigator.of(context).pop(),
          CupertinoColors.systemBlue,
        ),
      ],
    ),
    transitionDuration: _dialogTransitionDuration,
  );
}

void cupertinoAlertDialogAction(BuildContext context, String title, String content, VoidCallback onConfirm) {
  final locale = AppLocalizations.of(context);
  final theme = Theme.of(context);
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: _buildDialogTitleText(theme, title),
      content: _buildDialogContentText(theme, content),
      actions: [
        _buildDialogAction(
          theme,
          locale.translate('button.cancel'),
          () => Navigator.of(context).pop(),
          _errorColor,
        ),
        _buildDialogAction(
          theme,
          locale.translate('button.confirm'),
          () {
            Navigator.of(context).pop();
            onConfirm();
          },
          CupertinoColors.systemBlue,
        ),
      ],
    ),
  );
}

Widget _buildDialogTitleText(ThemeData theme, String text) => Text(
  text,
  style: theme.textTheme.titleMedium?.copyWith(color: CupertinoColors.black, fontSize: 18.0),
);

Widget _buildDialogContentText(ThemeData theme, String text) => Text(
  text,
  style: theme.textTheme.bodyMedium?.copyWith(color: CupertinoColors.black),
);

Widget _buildDialogAction(ThemeData theme, String label, VoidCallback onPressed, Color color) => CupertinoDialogAction(
  onPressed: onPressed,
  child: Text(
    label,
    style: theme.textTheme.bodyMedium?.copyWith(color: color),
  ),
);
