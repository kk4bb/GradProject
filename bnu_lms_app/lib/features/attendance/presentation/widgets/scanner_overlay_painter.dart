import 'package:flutter/material.dart';
import '../../../../shared/resources/colors_manager.dart';

class ScannerOverlayPainter extends CustomPainter {
  final double cutoutSize;
  final double borderRadius;

  const ScannerOverlayPainter({
    required this.cutoutSize,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.65);

    final screenWidth = size.width;
    final screenHeight = size.height;

    // Cutout rect positioned in center of the viewport
    final cutoutLeft = (screenWidth - cutoutSize) / 2;
    final cutoutTop = (screenHeight - cutoutSize) / 2;
    final cutoutRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cutoutLeft, cutoutTop, cutoutSize, cutoutSize),
      Radius.circular(borderRadius),
    );

    // Draw dark overlay everywhere except the cutout
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight)),
        Path()..addRRect(cutoutRect),
      ),
      paint,
    );

    // Draw glowing cyan corner-brackets around cutout
    final borderPaint = Paint()
      ..color = ColorsManager.blue // Cyan/Blue Brand theme accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final double cornerLength = 24;

    // Top Left corner
    canvas.drawPath(
      Path()
        ..moveTo(cutoutLeft, cutoutTop + cornerLength)
        ..lineTo(cutoutLeft, cutoutTop + borderRadius)
        ..quadraticBezierTo(cutoutLeft, cutoutTop, cutoutLeft + borderRadius, cutoutTop)
        ..lineTo(cutoutLeft + cornerLength, cutoutTop),
      borderPaint,
    );

    // Top Right corner
    canvas.drawPath(
      Path()
        ..moveTo(cutoutLeft + cutoutSize - cornerLength, cutoutTop)
        ..lineTo(cutoutLeft + cutoutSize - borderRadius, cutoutTop)
        ..quadraticBezierTo(cutoutLeft + cutoutSize, cutoutTop, cutoutLeft + cutoutSize, cutoutTop + borderRadius)
        ..lineTo(cutoutLeft + cutoutSize, cutoutTop + cornerLength),
      borderPaint,
    );

    // Bottom Left corner
    canvas.drawPath(
      Path()
        ..moveTo(cutoutLeft, cutoutTop + cutoutSize - cornerLength)
        ..lineTo(cutoutLeft, cutoutTop + cutoutSize - borderRadius)
        ..quadraticBezierTo(cutoutLeft, cutoutTop + cutoutSize, cutoutLeft + borderRadius, cutoutTop + cutoutSize)
        ..lineTo(cutoutLeft + cornerLength, cutoutTop + cutoutSize),
      borderPaint,
    );

    // Bottom Right corner
    canvas.drawPath(
      Path()
        ..moveTo(cutoutLeft + cutoutSize - cornerLength, cutoutTop + cutoutSize)
        ..lineTo(cutoutLeft + cutoutSize - borderRadius, cutoutTop + cutoutSize)
        ..quadraticBezierTo(cutoutLeft + cutoutSize, cutoutTop + cutoutSize, cutoutLeft + cutoutSize, cutoutTop + cutoutSize - borderRadius)
        ..lineTo(cutoutLeft + cutoutSize, cutoutTop + cutoutSize - cornerLength),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) => false;
}
