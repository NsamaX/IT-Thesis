import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/utils/nfc_helper.dart';

import '../../cubits/NFC/cubit.dart';

class NFCReaderWidget extends StatelessWidget {
  const NFCReaderWidget({
    super.key,
  });

  static const Duration animationDuration = Duration(milliseconds: 600);
  static const double iconSize = 40.0;
  static const double largeIconSize = 120.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<NFCCubit>();

    return BlocSelector<NFCCubit, NFCState, bool>(
      selector: (state) => state.isNFCEnabled,
      builder: (context, isNFCEnabled) {
        final Color activeColor = theme.primaryColor;
        final Color inactiveColor = theme.appBarTheme.backgroundColor ?? Colors.grey;
        final Color currentColor = isNFCEnabled ? activeColor : inactiveColor;

        return GestureDetector(
          onTap: () => NFCHelper.handleToggleNFC(cubit, enable: !isNFCEnabled),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildRotatingIcon(-90.0, const Offset(iconSize + 6.0, 0.0), currentColor),
              const SizedBox(width: 4.0),
              _buildCircleIcon(currentColor),
              const SizedBox(width: 4.0),
              _buildRotatingIcon(90.0, const Offset(-iconSize - 6.0, 0.0), currentColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRotatingIcon(
    double angle, 
    Offset offset, 
    Color color,
  ) {
    return Transform.translate(
      offset: offset,
      child: AnimatedRotation(
        duration: animationDuration,
        turns: angle / 360,
        curve: Curves.easeInOut,
        child: Icon(
          Icons.wifi_rounded,
          size: largeIconSize,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCircleIcon(
    Color color,
  ) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: animationDuration,
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
