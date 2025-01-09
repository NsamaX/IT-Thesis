import 'package:flutter/material.dart';

class CardQuantityWidget extends StatelessWidget {
  final int quantityCount;
  final int selectedQuantity;
  final ValueChanged<int> onSelected;

  const CardQuantityWidget({
    Key? key,
    this.quantityCount = 4,
    required this.selectedQuantity,
    required this.onSelected,
  })  : assert(quantityCount > 0, 'quantityCount must be greater than 0'),
        assert(selectedQuantity > 0 && selectedQuantity <= quantityCount, 'selectedQuantity must be within 1 to quantityCount'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double borderRadiusValue = 12;
    const double boxWidth = 60;
    const double boxHeight = 40;

    return SizedBox(
      height: boxHeight + 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: boxWidth * quantityCount + boxWidth,
            height: boxHeight,
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
              borderRadius: BorderRadius.circular(borderRadiusValue),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment(
              -1 + (2 * (selectedQuantity - 1) / (quantityCount - 1)),
              0,
            ),
            child: Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadiusValue),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              quantityCount * 2 - 1,
              (index) {
                if (index.isOdd) {
                  return Container(
                    width: 1,
                    height: boxHeight * 0.6,
                    color: theme.dividerColor,
                  );
                }
                final actualIndex = index ~/ 2;
                final isSelected = selectedQuantity == actualIndex + 1;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(actualIndex + 1),
                  child: SizedBox(
                    width: boxWidth,
                    height: boxHeight,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 400),
                        style: theme.textTheme.titleMedium?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.surface
                                  : theme.textTheme.titleMedium?.color,
                            ) ??
                            const TextStyle(),
                        child: Text('${actualIndex + 1}'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
