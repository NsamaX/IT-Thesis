import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nfc_project/core/locales/localizations.dart';

const _snackBarDuration = Duration(seconds: 1);
const _dialogTransitionDuration = Duration(milliseconds: 200);

const _successColor = CupertinoColors.systemGreen;
const _errorColor = CupertinoColors.systemRed;

Future<void> snackBar(
  BuildContext context, {
  required String content,
  bool isError = false,
}) async => Future.delayed(
  _snackBarDuration,
  () => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content, style: const TextStyle(color: Colors.white)),
      duration: _snackBarDuration,
      backgroundColor: isError ? _errorColor : _successColor,
    ),
  ),
);

void cupertinoAlertDialog(
  BuildContext context, {
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
    pageBuilder: (context, animation1, animation2) => CupertinoAlertDialog(
      title: _buildDialogTitleText(theme, title),
      content: _buildDialogContentText(theme, content),
      actions: [
        _buildDialogAction(
          theme,
          label: locale.translate('button.ok'),
          onPressed: () => Navigator.of(context).pop(),
          color: CupertinoColors.systemBlue,
        ),
      ],
    ),
    transitionDuration: _dialogTransitionDuration,
  );
}

void cupertinoAlertDialogAction(
  BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
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
          label: locale.translate('button.cancel'),
          onPressed: () => Navigator.of(context).pop(),
          color: _errorColor,
        ),
        _buildDialogAction(
          theme,
          label: locale.translate('button.confirm'),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          color: CupertinoColors.systemBlue,
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

Widget _buildDialogAction(
  ThemeData theme, {
  required String label,
  required VoidCallback onPressed,
  required Color color,
}) => CupertinoDialogAction(
  onPressed: onPressed,
  child: Text(
    label,
    style: theme.textTheme.bodyMedium?.copyWith(color: color),
  ),
);
