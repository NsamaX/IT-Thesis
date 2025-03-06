import 'package:flutter/material.dart';

class CardQuantityWidget extends StatelessWidget {
  final ValueChanged<int> onSelected;
  final int quantityCount;
  final int selectedQuantity;

  const CardQuantityWidget({
    super.key,
    required this.onSelected,
    required this.quantityCount,
    required this.selectedQuantity,
  });

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
              _buildBackground(theme, boxWidth, boxHeight, borderRadiusValue),
              _buildSelectedBox(boxWidth, boxHeight, borderRadiusValue),
              _buildQuantityBox(theme, boxWidth, boxHeight),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackground(
    ThemeData theme, 
    double width, 
    double height, 
    double borderRadius,
  ) {
    return Container(
      width: width * quantityCount + 20.0,
      height: height,
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildSelectedBox(
    double width, 
    double height, 
    double borderRadius,
  ) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      left: (selectedQuantity - 1) * width + (selectedQuantity - 1) * 6.6,
      top: 10,
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
    double width, 
    double height,
  ) {
    return SizedBox(
      width: width * quantityCount + 20.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          quantityCount * 2 - 1,
          (index) {
            if (index.isOdd) {
              return Container(
                width: 0.8,
                height: height * 0.6,
                color: theme.dividerColor,
              );
            }

            final actualIndex = index ~/ 2;
            final bool isSelected = selectedQuantity == actualIndex + 1;

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
    );
  }
}
