import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:nfc_project/core/locales/localizations.dart';

class DeckInsightChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cardStats;

  const DeckInsightChartWidget({
    super.key, 
    required this.cardStats,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final List<Map<String, dynamic>> data = _generateData(context);

    final List<int> drawCounts = data.map((stat) => stat['draw'] as int).toList();
    final List<int> returnCounts = data.map((stat) => stat['return'] as int).toList();

    return Column(
      children: [
        const SizedBox(height: 8.0),
        _buildLegend(locale, theme),
        const SizedBox(height: 8.0),
        _buildChart(theme, drawCounts, returnCounts, data),
      ],
    );
  }

  List<Map<String, dynamic>> _generateData(
    BuildContext context,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double barWidth = 40.0;
    const int minBars = 8;

    int maxBars = (screenWidth / barWidth).floor();
    maxBars = maxBars < minBars ? minBars : maxBars;

    final Map<String, Map<String, dynamic>> aggregatedData = {};
    for (final stat in cardStats) {
      final String cardName = stat['CardName'];
      if (cardName.isEmpty) continue;

      aggregatedData.putIfAbsent(cardName, () => {'CardName': cardName, 'draw': 0, 'return': 0});
      aggregatedData[cardName]!['draw'] += stat['draw'] as int;
      aggregatedData[cardName]!['return'] += stat['return'] as int;
    }

    final List<Map<String, dynamic>> data = aggregatedData.values.toList();
    while (data.length < maxBars) {
      data.add({'CardName': '', 'draw': 0, 'return': 0});
    }

    return data;
  }

  Widget _buildLegend(
    AppLocalizations locale, 
    ThemeData theme,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildLegendItem(theme, locale.translate('text.draw'), CupertinoColors.activeBlue),
          const SizedBox(width: 12.0),
          _buildLegendItem(theme, locale.translate('text.return'), CupertinoColors.destructiveRed),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    ThemeData theme, 
    String label, 
    Color color,
  ) {
    return Row(
      children: [
        Container(width: 12.0, height: 12.0, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8.0),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildChart(
    ThemeData theme, 
    List<int> drawCounts, 
    List<int> returnCounts, 
    List<Map<String, dynamic>> data,
  ) {
    final color = theme.appBarTheme.backgroundColor ?? Colors.grey;
    final maxY = 10;
    final double width = 40.0 * drawCounts.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildYAxis(theme, maxY, color),
        const SizedBox(width: 8.0),
        _buildLeftBorder(color),
        _buildChartBody(theme, width, maxY.toDouble(), drawCounts, returnCounts, data, color),
      ],
    );
  }

  Widget _buildYAxis(
    ThemeData theme, 
    int maxY, 
    Color color,
  ) {
    const double chartHeight = 400.0;
    final double spacerHeight = chartHeight / maxY - 24.0;

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          maxY,
          (index) => Column(
            children: [
              Text((maxY - index).toString(), style: theme.textTheme.bodySmall),
              SizedBox(height: spacerHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftBorder(
    Color color,
  ) {
    return Container(
      width: 1.2,
      height: 346.0,
      color: color,
    );
  }

  Widget _buildChartBody(
    ThemeData theme,
    double width,
    double maxY,
    List<int> drawCounts,
    List<int> returnCounts,
    List<Map<String, dynamic>> data,
    Color color,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: width,
            height: 400.0,
            child: BarChart(
              BarChartData(
                barGroups: List.generate(
                  drawCounts.length,
                  (index) => _buildBarGroup(maxY + 1, index, drawCounts[index], returnCounts[index]),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60.0,
                      getTitlesWidget: (value, meta) {
                        return value.toInt() < data.length
                            ? _buildBottomTitle(theme, data[value.toInt()]['CardName'])
                            : Container();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: _buildGrid(color),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: color, width: 1.2),
                    left: BorderSide(color: Colors.transparent),
                  ),
                ),
                maxY: maxY + 1,
                minY: 0,
                barTouchData: BarTouchData(enabled: false),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTitle(
    ThemeData theme, 
    String cardName,
  ) {
    final truncatedName = cardName.length > 10 ? '${cardName.substring(0, 10)}...' : cardName;

    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Transform.rotate(
        angle: 45 * 3.14159 / 180,
        child: Text(
          truncatedName,
          style: theme.textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(
    double maxY, 
    int index, 
    int drawCount, 
    int returnCount,
  ) {
    return BarChartGroupData(
      x: index,
      barsSpace: 6.0,
      barRods: [
        BarChartRodData(toY: drawCount > maxY ? maxY : drawCount.toDouble(), color: CupertinoColors.activeBlue, width: 4.0),
        BarChartRodData(toY: returnCount > maxY ? maxY : returnCount.toDouble(), color: CupertinoColors.destructiveRed, width: 4.0),
      ],
    );
  }

  FlGridData _buildGrid(
    Color color,
  ) {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      verticalInterval: 1.0,
      horizontalInterval: 1.0,
      getDrawingHorizontalLine: (value) => FlLine(color: color, strokeWidth: 1.2),
      getDrawingVerticalLine: (value) => FlLine(color: color, strokeWidth: 1.2),
    );
  }
}
