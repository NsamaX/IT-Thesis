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
    const double borderRadiusValue = 12.0;
    const double boxWidth = 60.0;
    const double boxHeight = 40.0;
    return SizedBox(
      height: boxHeight + 20.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackground(
            context,
            boxWidth: boxWidth,
            boxHeight: boxHeight,
            borderRadiusValue: borderRadiusValue,
          ),
          _buildSelectedBox(
            boxWidth: boxWidth,
            boxHeight: boxHeight,
            borderRadiusValue: borderRadiusValue,
          ),
          _buildQuantityBox(
            context,
            boxWidth: boxWidth,
            boxHeight: boxHeight,
            borderRadiusValue: borderRadiusValue,
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(
    BuildContext context, {
    required double boxWidth,
    required double boxHeight,
    required double borderRadiusValue,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: boxWidth * quantityCount + boxWidth,
      height: boxHeight,
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
    );
  }

  Widget _buildSelectedBox({
    required double boxWidth,
    required double boxHeight,
    required double borderRadiusValue,
  }) {
    return AnimatedAlign(
      alignment: Alignment(
        -1 + (2 * (selectedQuantity - 1) / (quantityCount - 1)),
        0,
      ),
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
      ),
    );
  }

  Widget _buildQuantityBox(
    BuildContext context, {
    required double boxWidth,
    required double boxHeight,
    required double borderRadiusValue,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        quantityCount * 2 - 1,
        (index) {
          if (index.isOdd) return Container(
            width: 1,
            height: boxHeight * 0.6,
            color: theme.dividerColor,
          );
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
    );
  }
}
