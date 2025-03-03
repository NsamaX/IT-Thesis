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

    const borderRadius = BorderRadius.all(Radius.circular(12.0));
    const double boxWidth = 160.0;
    const double boxHeight = 40.0;

    final items = [
      locale.translate('toggle.deck'),
      locale.translate('toggle.insight'),
    ];

    return SizedBox(
      width: boxWidth * items.length,
      height: boxHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [

          // Background Container
          Container(
            width: boxWidth * items.length,
            height: boxHeight,
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
              borderRadius: borderRadius,
            ),
          ),

          // Animated Selected Box
          AnimatedAlign(
            alignment: Alignment(
              isAnalyzeModeEnabled ? 1 : -1,
              0,
            ),
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: boxWidth,
              height: boxHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius,
              ),
            ),
          ),

          // Text Options
          Row(
            children: List.generate(items.length, (index) {
              final isSelected = (index == 1) == isAnalyzeModeEnabled;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(index == 1),
                  child: SizedBox(
                    height: boxHeight,
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
            }),
          ),
        ],
      ),
    );
  }
}
