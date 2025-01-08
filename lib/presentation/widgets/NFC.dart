import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import '../cubits/NFC.dart';

class NFCWidget extends StatelessWidget {
  const NFCWidget({Key? key}) : super(key: key);

  static const Duration animationDuration = Duration(milliseconds: 600);
  static const double iconSize = 40;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<NFCCubit>();

    return BlocBuilder<NFCCubit, NFCState>(
      builder: (context, state) {
        final bool isNFCEnabled = state.isNFCEnabled;
        final Color activeColor = theme.colorScheme.primary;
        final Color inactiveColor = theme.appBarTheme.backgroundColor ?? Colors.grey;

        return GestureDetector(
          onTap: () => NFCHelper.handleToggleNFC(cubit, enable: !isNFCEnabled),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNFCIcon(
                angle: -90,
                offset: Offset(iconSize + 6, 0),
                color: isNFCEnabled ? activeColor : inactiveColor,
              ),
              const SizedBox(width: 4),
              _buildNFCCircleIcon(
                color: isNFCEnabled ? activeColor : inactiveColor,
              ),
              const SizedBox(width: 4),
              _buildNFCIcon(
                angle: 90,
                offset: Offset(-iconSize - 6, 0),
                color: isNFCEnabled ? activeColor : inactiveColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNFCIcon({
    required double angle,
    required Offset offset,
    required Color color,
  }) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle * 3.14 / 180,
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          child: Icon(
            Icons.wifi_rounded,
            size: 120,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildNFCCircleIcon({required Color color}) {
    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      width: iconSize / 1.2,
      height: iconSize / 1.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
