import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/NFC.dart';

class NFCWidget extends StatelessWidget {
  const NFCWidget({Key? key}) : super(key: key);

  static const Duration animationDuration = Duration(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NFCCubit, NFCState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final double icon = 40;
        final bool isNFCEnabled = state.isNFCEnabled;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildNFCIcon(context, -90, Offset(icon + 6, 0), isNFCEnabled),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () async {
                final nfcCubit = context.read<NFCCubit>();
                if (!state.isNFCEnabled) {
                  nfcCubit.toggleNFC();
                  await nfcCubit.startRead();
                } else {
                  nfcCubit.toggleNFC();
                  nfcCubit.stopSession();
                }
              },
              child: AnimatedContainer(
                duration: animationDuration,
                width: icon / 1.2,
                height: icon / 1.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isNFCEnabled
                      ? theme.secondaryHeaderColor
                      : theme.appBarTheme.backgroundColor,
                ),
              ),
            ),
            const SizedBox(width: 4),
            buildNFCIcon(context, 90, Offset(-icon - 6, 0), isNFCEnabled),
          ],
        );
      },
    );
  }

  Widget buildNFCIcon(
    BuildContext context,
    double angle,
    Offset offset,
    bool isNFCEnabled,
  ) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        final nfcCubit = context.read<NFCCubit>();
        if (!isNFCEnabled) {
          nfcCubit.toggleNFC();
          await nfcCubit.startRead();
        } else {
          nfcCubit.toggleNFC();
          nfcCubit.stopSession();
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
