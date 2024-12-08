import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/NFC.dart';

class NFCWidget extends StatelessWidget {
  const NFCWidget({Key? key}) : super(key: key);

  static const Duration animationDuration = Duration(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = 40;
    final cubit = context.read<NFCCubit>();
    return BlocBuilder<NFCCubit, NFCState>(
      builder: (context, state) {
        final bool isNFCEnabled = state.isNFCEnabled;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNFCIcon(theme, cubit, -90, Offset(iconSize + 6, 0), isNFCEnabled),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () async {
                if (!isNFCEnabled) {
                  cubit.toggleNFC();
                  await cubit.start();
                } else {
                  await cubit.stopSession(reason: "User toggled off NFC");
                }
              },
              child: AnimatedContainer(
                duration: animationDuration,
                width: iconSize / 1.2,
                height: iconSize / 1.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isNFCEnabled
                      ? theme.secondaryHeaderColor
                      : theme.appBarTheme.backgroundColor,
                ),
              ),
            ),
            const SizedBox(width: 4),
            _buildNFCIcon(theme, cubit, 90, Offset(-iconSize - 6, 0), isNFCEnabled),
          ],
        );
      },
    );
  }

  Widget _buildNFCIcon(ThemeData theme, NFCCubit cubit, double angle, Offset offset, bool isNFCEnabled) {
    return GestureDetector(
      onTap: () async {
        if (!isNFCEnabled) {
          cubit.toggleNFC();
          await cubit.start();
        } else {
          await cubit.stopSession(reason: "User toggled off NFC");
        }
      },
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: angle * 3.1415927 / 180,
          child: AnimatedContainer(
            duration: animationDuration,
            child: Icon(
              Icons.wifi_rounded,
              size: 120,
              color: isNFCEnabled
                  ? theme.secondaryHeaderColor
                  : theme.appBarTheme.backgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
