import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import '../cubits/NFC.dart';

class NFCWidget extends StatelessWidget {
  const NFCWidget({Key? key}) : super(key: key);

  static const Duration animationDuration = Duration(milliseconds: 600);
  static const double iconSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<NFCCubit>();
    return BlocBuilder<NFCCubit, NFCState>(
      builder: (context, state) {
        final isNFCEnabled = state.isNFCEnabled;
        final activeColor = theme.primaryColor;
        final inactiveColor = theme.appBarTheme.backgroundColor ?? Colors.grey;
        return GestureDetector(
          onTap: () => NFCHelper.handleToggleNFC(cubit, enable: !isNFCEnabled),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNFCIcon(
                angle: -90,
                offset: const Offset(iconSize + 6.0, 0.0),
                color: isNFCEnabled ? activeColor : inactiveColor,
              ),
              const SizedBox(width: 4.0),
              _buildNFCCircleIcon(color: isNFCEnabled ? activeColor : inactiveColor),
              const SizedBox(width: 4.0),
              _buildNFCIcon(
                angle: 90,
                offset: const Offset(-iconSize - 6.0, 0.0),
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
        angle: angle * 3.14 / 180.0,
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: animationDuration,
          child: Icon(
            Icons.wifi_rounded,
            size: 120.0,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildNFCCircleIcon({required Color color}) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: animationDuration,
      width: iconSize / 1.2,
      height: iconSize / 1.2,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
