import 'package:flutter/material.dart';

class QuantityWidget extends StatelessWidget {
  final int quantityCount;
  final int selectedQuantity;
  final ValueChanged<int> onSelected;

  const QuantityWidget({
    super.key,
    this.quantityCount = 4,
    required this.selectedQuantity,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double borderRadiusValue = 12;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.appBarTheme.backgroundColor,
            borderRadius: BorderRadius.circular(borderRadiusValue),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              quantityCount,
              (index) {
                final isSelected = selectedQuantity == index + 1;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onSelected(index + 1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : theme.appBarTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? Colors.black
                              : theme.textTheme.titleMedium?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
