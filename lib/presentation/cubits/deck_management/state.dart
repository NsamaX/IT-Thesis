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
class DeckManagerState {
  final List<DeckEntity> decks;
  final DeckEntity deck;
  final CardEntity? selectedCard;
  final int quantity;
  final bool isEditModeEnabled;
  final bool isShareEnabled;
  final bool isNFCEnabled;
  final bool isdeleteEnabled;
  final bool isLoading;

  DeckManagerState({
    required this.decks,
    required this.deck,
    this.selectedCard,
    this.quantity = 1,
    this.isEditModeEnabled = false,
    this.isShareEnabled = false,
    this.isNFCEnabled = false,
    this.isdeleteEnabled = false,
    this.isLoading = false,
  });

  DeckManagerState copyWith({
    List<DeckEntity>? decks,
    DeckEntity? deck,
    CardEntity? selectedCard,
    int? quantity,
    bool? isEditModeEnabled,
    bool? isShareEnabled,
    bool? isNFCEnabled,
    bool? isdeleteEnabled,
    bool? isLoading,
  }) => DeckManagerState(
    decks: decks ?? this.decks,
    deck: deck ?? this.deck,
    selectedCard: selectedCard ?? this.selectedCard,
    quantity: quantity ?? this.quantity,
    isEditModeEnabled: isEditModeEnabled ?? this.isEditModeEnabled,
    isShareEnabled: isShareEnabled ?? this.isShareEnabled,
    isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
    isdeleteEnabled: isdeleteEnabled ?? this.isdeleteEnabled,
    isLoading: isLoading ?? this.isLoading,
  );
}
