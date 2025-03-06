import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';

import 'package:nfc_project/domain/entities/deck.dart';

import '../../cubits/deck_management/cubit.dart';
import '../../cubits/NFC/cubit.dart';

void createNewDeck(BuildContext context, DeckManagerCubit cubit, AppLocalizations locale) async {
  final newDeck = DeckEntity(
    deckId: const Uuid().v4(),
    deckName: locale.translate('title.new_deck'),
    cards: {},
  );
  cubit.setDeck(newDeck);
  await cubit.saveDeck(context.read<NFCCubit>());
  if (context.read<DeckManagerCubit>().state.isEditModeEnabled) {
    cubit.toggleEditMode();
  }
  Navigator.of(context).pushNamed(AppRoutes.newDeck);
}
