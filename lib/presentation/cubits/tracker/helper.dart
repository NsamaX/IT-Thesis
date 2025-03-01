part of 'cubit.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
void updateCardCount(TagEntity tag, Action action, String location, int delta, TrackState state, Function emit) {
  final cardEntry = state.currentDeck.cards.entries.firstWhere(
    (entry) => entry.key.cardId == tag.cardId,
    orElse: () => throw Exception("Card not found in deck"),
  );
  final currentCount = cardEntry.value;
  if ((currentCount + delta) < 0) return;
  final updatedCards = {...state.currentDeck.cards};
  updatedCards[cardEntry.key] = (currentCount + delta).clamp(0, double.infinity).toInt();
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
  emit(state.copyWith(
    deck: state.currentDeck.copyWith(cards: updatedCards),
    record: state.record.copyWith(data: updatedData),
  ));
}

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
void moveCardToTop(TagEntity tag, TrackState state, Function emit) {
  final updatedCards = {...state.currentDeck.cards};
  final cardEntry = updatedCards.entries.firstWhere(
    (entry) => entry.key.cardId == tag.cardId,
    orElse: () => throw Exception("Card not found in deck"),
  );
  updatedCards.remove(cardEntry.key);
  emit(state.copyWith(
    deck: state.currentDeck.copyWith(cards: {cardEntry.key: cardEntry.value, ...updatedCards}),
  ));
}
