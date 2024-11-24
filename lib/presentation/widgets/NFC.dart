import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/NFC.dart';

class NFCWidget extends StatelessWidget {
  const NFCWidget({Key? key}) : super(key: key);

  static const Duration animationDuration = Duration(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NFCCubit, bool>(
      builder: (context, NFCDetected) {
        final theme = Theme.of(context);
        final double icon = 40;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildNFCIcon(context, -90, Offset(icon + 6, 0), NFCDetected),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => context.read<NFCCubit>().toggleNFCStatus(),
              child: AnimatedContainer(
                duration: animationDuration,
                width: icon / 1.2,
                height: icon / 1.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NFCDetected
                      ? theme.secondaryHeaderColor
                      : theme.appBarTheme.backgroundColor,
                ),
              ),
            ),
            const SizedBox(width: 4),
            buildNFCIcon(context, 90, Offset(-icon - 6, 0), NFCDetected),
          ],
        );
      },
    );
  }

  Widget buildNFCIcon(
    BuildContext context,
    double angle,
    Offset offset,
    bool NFCDetected,
  ) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.read<NFCCubit>().toggleNFCStatus(),
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: angle * 3.1415927 / 180,
          child: AnimatedContainer(
            duration: animationDuration,
            child: Icon(
              Icons.wifi_rounded,
              size: 120,
              color: NFCDetected
                  ? theme.secondaryHeaderColor
                  : theme.appBarTheme.backgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
