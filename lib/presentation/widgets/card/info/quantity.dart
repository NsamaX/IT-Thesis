import 'package:flutter/material.dart';

class QuantityWidget extends StatelessWidget {
  final int quantityCount;
  final int selectedQuantity;
  final ValueChanged<int> onSelected;

  const QuantityWidget({
    Key? key,
    this.quantityCount = 4,
    required this.selectedQuantity,
    required this.onSelected,
  }) : super(key: key);

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
            width: boxWidth * quantityCount + boxWidth / 2,
            height: boxHeight,
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
              borderRadius: BorderRadius.circular(borderRadiusValue),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
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
              quantityCount,
              (index) {
                final isSelected = selectedQuantity == index + 1;
                return GestureDetector(
                  onTap: () => onSelected(index + 1),
                  child: SizedBox(
                    width: boxWidth,
                    height: boxHeight,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: theme.textTheme.titleMedium?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.surface
                                  : theme.textTheme.titleMedium?.color,
                            ) ??
                            const TextStyle(),
                        child: Text('${index + 1}'),
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
