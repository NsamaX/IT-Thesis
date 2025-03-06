part of 'cubit.dart';

void updateCardCount(TagEntity tag, Action action, String location, int delta, DeckTrackState state, void Function(DeckTrackState) safeEmit) {
  final defaultEntry = MapEntry(CardEntity(cardId: tag.cardId, game: '', name: 'Unknown'), 0);
  
  final cardEntry = state.currentDeck.cards.entries.firstWhere(
    (entry) => entry.key.cardId == tag.cardId,
    orElse: () => defaultEntry,
  );

  if (!state.currentDeck.cards.containsKey(cardEntry.key)) {
    print("Warning: Card not found in deck (${tag.cardId})");
    return;
  }

  final currentCount = cardEntry.value;
  final newCount = (currentCount + delta).clamp(0, double.infinity).toInt();

  if (newCount == currentCount) return;

  final updatedCards = {...state.currentDeck.cards}..[cardEntry.key] = newCount;
  final updatedData = [
    ...state.record.data,
    DataEntity(
      tagId: tag.tagId,
      name: cardEntry.key.name,
      imageUrl: cardEntry.key.imageUrl ?? '',
      location: location,
      action: action,
      timestamp: DateTime.now(),
    ),
  ];

  safeEmit(state.copyWith(
    currentDeck: state.currentDeck.copyWith(cards: updatedCards),
    record: state.record.copyWith(data: updatedData),
  ));
}

void moveCardToTop(TagEntity tag, DeckTrackState state, void Function(DeckTrackState) safeEmit) {
  final defaultEntry = MapEntry(CardEntity(cardId: tag.cardId, game: '', name: 'Unknown'), 0);
  
  final cardEntry = state.currentDeck.cards.entries.firstWhere(
    (entry) => entry.key.cardId == tag.cardId,
    orElse: () => defaultEntry,
  );

  if (!state.currentDeck.cards.containsKey(cardEntry.key)) {
    print("Warning: Card not found in deck (${tag.cardId})");
    return;
  }

  final updatedCards = {...state.currentDeck.cards}..remove(cardEntry.key);
  safeEmit(state.copyWith(
    currentDeck: state.currentDeck.copyWith(cards: {cardEntry.key: cardEntry.value, ...updatedCards}),
  ));
}
