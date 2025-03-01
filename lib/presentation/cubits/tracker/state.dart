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
class TrackState {
  final DeckEntity initialDeck;
  final DeckEntity currentDeck;
  final RecordEntity record;
  final List<RecordEntity> records;
  final List<CardEntity> history;
  final Map<String, Color> cardColors;
  final bool isDialogShown;
  final bool isProcessing;
  final bool isAdvanceModeEnabled;
  final bool isAnalyzeModeEnabled;

  TrackState({
    required this.initialDeck,
    required this.currentDeck,
    required this.record,
    this.records = const [],
    this.history = const [],
    this.cardColors = const {},
    this.isDialogShown = false,
    this.isProcessing = false,
    this.isAdvanceModeEnabled = false,
    this.isAnalyzeModeEnabled = false,
  });

  TrackState copyWith({
    DeckEntity? initialDeck,
    DeckEntity? deck,
    RecordEntity? record,
    List<RecordEntity>? records,
    List<CardEntity>? history,
    Map<String, Color>? cardColors,
    bool? isDialogShown,
    bool? isProcessing,
    bool? isAdvanceModeEnabled,
    bool? isAnalyzeModeEnabled,
  }) => TrackState(
    initialDeck: initialDeck ?? this.initialDeck,
    currentDeck: deck ?? this.currentDeck,
    record: record ?? this.record,
    records: records ?? this.records,
    history: history ?? this.history,
    cardColors: cardColors ?? this.cardColors,
    isDialogShown: isDialogShown ?? this.isDialogShown,
    isProcessing: isProcessing ?? this.isProcessing,
    isAdvanceModeEnabled: isAdvanceModeEnabled ?? this.isAdvanceModeEnabled,
    isAnalyzeModeEnabled: isAnalyzeModeEnabled ?? this.isAnalyzeModeEnabled,
  );
}
