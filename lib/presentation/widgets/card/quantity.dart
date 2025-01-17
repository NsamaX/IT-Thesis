import 'package:flutter/material.dart';

class CardQuantityWidget extends StatelessWidget {
  final ValueChanged<int> onSelected;
  final int quantityCount;
  final int selectedQuantity;

  const CardQuantityWidget({
    Key? key,
    required this.onSelected,
    required this.quantityCount,
    required this.selectedQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const double borderRadiusValue = 12.0;
    const double boxWidth = 60.0;
    const double boxHeight = 40.0;

    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          height: boxHeight + 20.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildBackground(theme, quantityCount, boxWidth, boxHeight, borderRadiusValue),
              _buildSelectedBox(boxWidth, boxHeight, borderRadiusValue),
              _buildQuantityBox(theme, quantityCount, boxWidth, boxHeight),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackground(
    ThemeData theme,
    int count,
    double width,
    double height,
    double borderRadius,
  ) {
    return Container(
      width: width * count + width,
      height: height,
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildSelectedBox(double width, double height, double borderRadius) {
    return AnimatedAlign(
      alignment: Alignment(
        -1 + (2 * (selectedQuantity - 1) / (quantityCount - 1)),
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
  }

  Widget _buildQuantityBox(
    ThemeData theme,
    int count,
    double width,
    double height,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        count * 2 - 1,
        (index) {
          if (index.isOdd) {
            return Container(
              width: 1,
              height: height * 0.6,
              color: theme.dividerColor,
            );
          }
          final actualIndex = index ~/ 2;
          final isSelected = selectedQuantity == actualIndex + 1;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSelected(actualIndex + 1),
            child: SizedBox(
              width: width,
              height: height,
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  style: theme.textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? theme.scaffoldBackgroundColor
                            : theme.textTheme.titleMedium?.color,
                      ) ?? const TextStyle(),
                  child: Text('${actualIndex + 1}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
