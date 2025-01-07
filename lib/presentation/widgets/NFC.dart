import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import '../cubits/NFC.dart';

class NFCWidget extends StatelessWidget {
  const NFCWidget({Key? key}) : super(key: key);

  static const Duration animationDuration = Duration(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double iconSize = 40;
    final cubit = context.read<NFCCubit>();

    return BlocBuilder<NFCCubit, NFCState>(
      builder: (context, state) {
        final bool isNFCEnabled = state.isNFCEnabled;

        return GestureDetector(
          onTap: () => NFCHelper.handleToggleNFC(cubit, enable: !isNFCEnabled),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNFCIcon(
                theme: theme,
                angle: -90,
                offset: Offset(iconSize + 6, 0),
                isNFCEnabled: isNFCEnabled,
              ),
              const SizedBox(width: 4),
              AnimatedContainer(
                duration: animationDuration,
                width: iconSize / 1.2,
                height: iconSize / 1.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isNFCEnabled
                      ? theme.colorScheme.primary
                      : theme.appBarTheme.backgroundColor,
                ),
              ),
              const SizedBox(width: 4),
              _buildNFCIcon(
                theme: theme,
                angle: 90,
                offset: Offset(-iconSize - 6, 0),
                isNFCEnabled: isNFCEnabled,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNFCIcon({
    required ThemeData theme,
    required double angle,
    required Offset offset,
    required bool isNFCEnabled,
  }) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle * 3.1415927 / 180,
        child: AnimatedContainer(
          duration: animationDuration,
          child: Icon(
            Icons.wifi_rounded,
            size: 120,
            color: isNFCEnabled
                ? theme.colorScheme.primary
                : theme.appBarTheme.backgroundColor,
          ),
        ),
      ),
    );
  }
}
