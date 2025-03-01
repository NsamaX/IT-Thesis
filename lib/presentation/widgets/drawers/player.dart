import 'package:flutter/material.dart';

import 'package:nfc_project/core/locales/localizations.dart';

class PlayerDrawerWidget extends StatelessWidget {
  const PlayerDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SizedBox(
      width: 160.0,
      height: 90.0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 200.0,
            height: 150.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.2 * 255).toInt()),
                  offset: const Offset(0.0, 4.0),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 16.0),
                      Icon(
                        Icons.qr_code_rounded,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        locale.translate('toggle.create_room'),
                        style: theme.textTheme.titleSmall?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Divider(height: 1, color: Colors.grey[300]),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      SizedBox(width: 16.0),
                      Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        locale.translate('toggle.join_room'),
                        style: theme.textTheme.titleSmall?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: DoubleTrianglePainter(color: Colors.white),
              size: const Size(200.0, 20.0),
            ),
          ),
        ],
      ),
    );
  }
}

class DoubleTrianglePainter extends CustomPainter {
  final Color color;

  DoubleTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;

    final Path leftTriangle = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..close();

    final Path rightTriangle = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, 0)
      ..close();

    canvas.drawPath(leftTriangle, paint);
    canvas.drawPath(rightTriangle, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
