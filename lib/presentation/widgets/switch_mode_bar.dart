import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';

class SwitchModeBarWidget extends StatelessWidget {
  final bool isAnalyzeModeEnabled;
  final ValueChanged<bool> onSelected;

  const SwitchModeBarWidget({
    Key? key,
    required this.isAnalyzeModeEnabled,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const double borderRadiusValue = 12.0;
    const double boxWidth = 160.0;
    const double boxHeight = 40.0;
    final items = [
      locale.translate('toggle.deck'),
      locale.translate('toggle.analyze')
    ];

    return SizedBox(
      width: boxWidth * items.length,
      height: boxHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackground(theme, items.length, boxWidth, boxHeight, borderRadiusValue),
          _buildSelectedBox(items.length, boxWidth, boxHeight, borderRadiusValue),
          _buildTextBoxes(theme, items, boxWidth, boxHeight),
        ],
      ),
    );
  }

  Widget _buildBackground(ThemeData theme, int count, double width, double height, double borderRadius) => Container(
    width: width * count,
    height: height,
    decoration: BoxDecoration(
      color: theme.appBarTheme.backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  );

  Widget _buildSelectedBox(int itemCount, double width, double height, double borderRadius) => AnimatedAlign(
    alignment: Alignment(
      isAnalyzeModeEnabled ? (1 / (itemCount - 1)) : -(1 / (itemCount - 1)),
      0,
    ),
    curve: Curves.easeInOut,
    duration: const Duration(milliseconds: 200),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );

  Widget _buildTextBoxes(ThemeData theme, List<String> items, double width, double height) => Row(
    children: List.generate(
      items.length,
      (index) {
        final isSelected = (index == 1) == isAnalyzeModeEnabled;
        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSelected(index == 1),
            child: SizedBox(
              height: height,
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  style: theme.textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? theme.scaffoldBackgroundColor
                            : theme.textTheme.titleMedium?.color,
                      ) ??
                      const TextStyle(),
                  child: Text(items[index]),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
