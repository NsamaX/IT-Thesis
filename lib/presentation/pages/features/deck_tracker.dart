import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/core/locales/localizations.dart';

import 'package:nfc_project/domain/entities/deck.dart';

import '../../cubits/deck_tracker/cubit.dart';
import '../../cubits/NFC/cubit.dart';

import '../../widgets/shared/notifications.dart';

void resetMultipleChoicesDialog(BuildContext context, DeckEntity deck) {
  cupertinoMultipleChoicesDialog(
    context,
    AppLocalizations.of(context).translate('dialog.reset_deck.title'),
    AppLocalizations.of(context).translate('dialog.reset_deck.content'),
    {
      AppLocalizations.of(context).translate('button.reset'): {
        'onPressed': () {
          context.read<DeckTrackCubit>().toggleReset();
          Navigator.of(context).pop();
        },
        'isCancel': false,
      },
      AppLocalizations.of(context).translate('toggle.save'): {
        'onPressed': () {
          context.read<DeckTrackCubit>().toggleSaveRecord();
          Navigator.of(context).pop();
        },
        'isCancel': false,
      },
      AppLocalizations.of(context).translate('button.cancel'): {
        'onPressed': () => Navigator.of(context).pop(),
        'isCancel': true,
      },
    },
  );
}

void toggleNFC(BuildContext context, NFCCubit nfcCubit, bool isNFCEnabled) {
  NFCHelper.handleToggleNFC(
    nfcCubit,
    enable: !isNFCEnabled,
    reason: 'User toggled NFC in Tracker Page',
  );
}

void showTrackerDialog(BuildContext context, AppLocalizations locale) {
  Future.microtask(() {
    context.read<DeckTrackCubit>().showDialog();
    cupertinoAlertDialog(
      context,
      locale.translate('dialog.tracker_tutorial.title'),
      locale.translate('dialog.tracker_tutorial.content'),
    );
  });
}
