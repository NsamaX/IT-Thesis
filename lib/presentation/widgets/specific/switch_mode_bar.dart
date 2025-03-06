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

  static const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(12.0));
  static const double _boxWidth = 160.0;
  static const double _boxHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final items = [
      locale.translate('toggle.deck'),
      locale.translate('toggle.insight'),
    ];

    return SizedBox(
      width: _boxWidth * items.length,
      height: _boxHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackgroundBar(theme, items.length),
          _buildAnimatedSwitch(),
          _buildButtons(items, theme),
        ],
      ),
    );
  }

  Widget _buildBackgroundBar(
    ThemeData theme, 
    int itemCount,
  ) {
    return Container(
      width: _boxWidth * itemCount,
      height: _boxHeight,
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: _borderRadius,
      ),
    );
  }

  Widget _buildAnimatedSwitch() {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: isAnalyzeModeEnabled ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: _boxWidth,
        height: _boxHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: _borderRadius,
        ),
      ),
    );
  }

  Widget _buildButtons(
    List<String> items, 
    ThemeData theme,
  ) {
    return Row(
      children: List.generate(items.length, (index) {
        final isSelected = (index == 1) == isAnalyzeModeEnabled;

        return Expanded(
          child: InkWell(
            onTap: () => onSelected(index == 1),
            borderRadius: _borderRadius,
            child: SizedBox(
              height: _boxHeight,
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  style: theme.textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? theme.scaffoldBackgroundColor
                            : theme.textTheme.titleMedium?.color,
                      ) ?? const TextStyle(),
                  child: Text(items[index]),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
