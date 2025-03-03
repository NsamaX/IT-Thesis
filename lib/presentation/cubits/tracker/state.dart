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
class TrackState extends Equatable {
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

  const TrackState({
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
    DeckEntity? currentDeck,
    RecordEntity? record,
    List<RecordEntity>? records,
    List<CardEntity>? history,
    Map<String, Color>? cardColors,
    bool? isDialogShown,
    bool? isProcessing,
    bool? isAdvanceModeEnabled,
    bool? isAnalyzeModeEnabled,
  }) {
    return TrackState(
      initialDeck: initialDeck ?? this.initialDeck,
      currentDeck: currentDeck ?? this.currentDeck,
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

  @override
  List<Object?> get props => [
        initialDeck,
        currentDeck,
        record,
        records,
        history,
        cardColors,
        isDialogShown,
        isProcessing,
        isAdvanceModeEnabled,
        isAnalyzeModeEnabled,
      ];
}
