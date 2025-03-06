import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/core/locales/localizations.dart';

import 'package:nfc_project/domain/entities/card.dart';

import '../../cubits/deck_management/cubit.dart';
import '../../cubits/NFC/cubit.dart';
import '../../cubits/collection.dart';

import '../../widgets/shared/notifications.dart';

Widget buildTextField(BuildContext context, AppLocalizations locale) {
  final collectionCubit = context.watch<CollectionCubit>();
  return TextField(
    controller: TextEditingController(text: collectionCubit.state.name)
      ..selection = TextSelection.collapsed(offset: collectionCubit.state.name.length),
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.titleMedium,
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: locale.translate('text.card_name'),
    ),
    onChanged: (value) {
      collectionCubit.setName(value.trim());
    },
  );
}

void toggleAdd(BuildContext context, AppLocalizations locale, DeckManagerCubit deckManagerCubit, CardEntity? card) async {
  if (card != null) {
    deckManagerCubit.addCard(card, deckManagerCubit.state.quantity);
    snackBar(
      context,
      locale.translate('snack_bar.card.add_success'),
    );
    Navigator.of(context).pop();
  }
}

void toggleCreate(BuildContext context, AppLocalizations locale) async {
  context.read<CollectionCubit>().addCard();
  snackBar(
    context,
    locale.translate('snack_bar.card.add_success'),
  );
}

void toggleNFC(BuildContext context, NFCCubit nfcCubit, bool isNFCEnabled, CardEntity? card) {
  NFCHelper.handleToggleNFC(
    nfcCubit,
    enable: !isNFCEnabled,
    card: card,
    reason: 'User toggled NFC in Card Page',
  );
}
