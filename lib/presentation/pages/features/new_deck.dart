import 'package:flutter/material.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import '../../cubits/deck_management/cubit.dart';

import '../../widgets/shared/notifications.dart';

void showDeleteDialog(BuildContext context, DeckManagerCubit cubit, AppLocalizations locale) {
  cupertinoAlertDialogAction(
    context,
    locale.translate('dialog.delete_deck.title'),
    locale.translate('dialog.delete_deck.content'),
    () {
      cubit.toggleDelete();
      snackBar(
        context,
        locale.translate('snack_bar.deck.deleted'),
      );
    },
  );
}

void renameDeck(DeckManagerCubit cubit, TextEditingController controller, AppLocalizations locale, String value) {
  final newName = value.trim().isNotEmpty
      ? value.trim()
      : locale.translate('title.new_deck');
  cubit.renameDeck(newName);
  controller.text = newName;
}

void toggleShare(BuildContext context, DeckManagerCubit cubit, AppLocalizations locale) {
  cubit.toggleShare();
  snackBar(
    context,
    locale.translate('snack_bar.deck.share'),
  );
}
