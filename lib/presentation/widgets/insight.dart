import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/data.dart' as Action;
import 'package:nfc_project/domain/entities/deck.dart';
import 'package:nfc_project/domain/entities/record.dart';

class InsightWidget extends StatelessWidget {
  final DeckEntity initialDeck;
  final RecordEntity record;
  final List<Map<String, dynamic>> cardStats;

  const InsightWidget({super.key, required this.initialDeck, required this.record, required this.cardStats});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final totalDraw = _calculateTotal('draw');
    final totalReturn = _calculateTotal('return');
    final percentagePlayed = _calculatePercentagePlayed();
    final unrecord = _calculateUnusedCards();

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
                locale.translate('analyze.content.percentage_played')
                    .replaceFirst('?', percentagePlayed.toStringAsFixed(1)),
              ),
              _buildInfoText(
                theme,
                locale.translate('analyze.content.total_draw')
                    .replaceAll('?+', totalDraw.toString())
                    .replaceAll('?-', totalReturn.toString()),
              ),
              _buildInfoText(
                theme,
                locale.translate('analyze.content.unused_cards')
                    .replaceAll('?', unrecord.toString()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(ThemeData theme, String content) => Text(
    '     ➜ $content',
    style: theme.textTheme.bodySmall,
  );

  int _calculateTotal(String key) => cardStats.fold(0, (total, card) => total + (card[key] as int));

  double _calculatePercentagePlayed() {
    final totalCardsInDeck = initialDeck.cards.entries.fold<int>(0, (sum, entry) => sum + entry.value);
    final usedCardNames = record.data
        .where((data) => data.action == Action.Action.draw)
        .map((data) => data.tagId)
        .toSet();
    final totalUsedCards = usedCardNames.length;
    if (totalCardsInDeck == 0) return 0.0;
    return (totalUsedCards / totalCardsInDeck) * 100;
  }

  int _calculateUnusedCards() {
    final drawnCardName = record.data
        .where((data) => data.action == Action.Action.draw)
        .map((data) => data.name)
        .toSet();
    final unusedCardNames = initialDeck.cards.keys
        .where((card) => !drawnCardName.contains(card.name))
        .map((card) => card.name)
        .toSet();
    return unusedCardNames.length;
  }
}
