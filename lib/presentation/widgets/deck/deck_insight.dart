import 'package:flutter/material.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import 'package:nfc_project/domain/entities/data.dart' as Action;
import 'package:nfc_project/domain/entities/deck.dart';
import 'package:nfc_project/domain/entities/record.dart';

import '../game/game_history.dart';

class DeckInsightWidget extends StatelessWidget {
  final DeckEntity initialDeck;
  final RecordEntity record;
  final List<RecordEntity> records;
  final void Function(BuildContext context, String recordId)? selectRecord;
  final List<Map<String, dynamic>> cardStats;

  const DeckInsightWidget({
    super.key, 
    required this.initialDeck, 
    required this.record, 
    this.selectRecord,
    required this.records,
    required this.cardStats,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final int totalDraw = _calculateTotal('draw');
    final int totalReturn = _calculateTotal('return');
    final double percentagePlayed = _calculatePercentagePlayed();
    final int unrecordedCards = _calculateUnusedCards();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnalysisSection(locale, theme, totalDraw, totalReturn, percentagePlayed, unrecordedCards),
        if (records.isNotEmpty) _buildHistoryWidget(),
      ],
    );
  }

  Widget _buildAnalysisSection(
    AppLocalizations locale, 
    ThemeData theme, 
    int totalDraw, 
    int totalReturn, 
    double percentagePlayed, 
    int unrecordedCards,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.translate('analyze.title'),
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
          ),
          const SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoText(
                theme,
                locale.translate('analyze.content.percentage_played').replaceFirst('?', percentagePlayed.toStringAsFixed(1)),
              ),
              _buildInfoText(
                theme,
                locale.translate('analyze.content.total_draw')
                    .replaceAll('?+', totalDraw.toString())
                    .replaceAll('?-', totalReturn.toString()),
              ),
              _buildInfoText(
                theme,
                locale.translate('analyze.content.unused_cards').replaceAll('?', unrecordedCards.toString()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(
    ThemeData theme, 
    String content,
  ) {
    return Opacity(
      opacity: 0.6,
      child: Text(
        '     ➜ $content',
        style: theme.textTheme.bodySmall,
      ),
    );
  }

  Widget _buildHistoryWidget() => GameHistoryWidget(records: records, selectRecord: selectRecord);

  int _calculateTotal(String key) => cardStats.fold(0, (total, card) => total + (card[key] as int));

  double _calculatePercentagePlayed() {
    final int totalCardsInDeck = initialDeck.cards.values.fold(0, (sum, count) => sum + count);
    final int totalUsedCards = record.data
        .where((data) => data.action == Action.Action.draw)
        .map((data) => data.tagId)
        .toSet()
        .length;
    
    return totalCardsInDeck == 0 ? 0.0 : (totalUsedCards / totalCardsInDeck) * 100;
  }

  int _calculateUnusedCards() {
    final Set<String> drawnCardNames = record.data
        .where((data) => data.action == Action.Action.draw)
        .map((data) => data.name)
        .toSet();
    
    return initialDeck.cards.keys.where((card) => !drawnCardNames.contains(card.name)).length;
  }
}
