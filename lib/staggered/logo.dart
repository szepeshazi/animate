import 'dart:math';

import 'package:flutter/material.dart';

class LogoWidget extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintCenter = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.greenAccent
      ..strokeWidth = 18.0;
    final paintEdge = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey
      ..strokeWidth = 2.0;
    const arcLength = pi / 3;

    final path = Path();
    path.arcTo(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height - 50),
          radius: size.width / 2),
       arcLength,
      _size,
      false,
    );
    canvas.drawPath(path, paintCenter);

    canvas.drawArc(
      Rect.fromLTRB(_size, _size, size.width - _size, size.height - _size),
      origin,
      arcLength,
      false,
      paintEdge,
    );
    canvas.drawArc(
      Rect.fromLTRB(0, 0, size.width, size.height),
      origin,
      arcLength,
      false,
      paintEdge,
    );

    _drawEdge(canvas: canvas, paint: paintEdge, size: size, radius: origin);
    _drawEdge(
        canvas: canvas,
        paint: paintEdge,
        size: size,
        radius: origin + arcLength);
  }

  void _drawEdge({
    required Canvas canvas,
    required Paint paint,
    required Size size,
    required double radius,
  }) {
    final cs = cos(radius);
    final sn = sin(radius);

    final r1 = size.width / 2;
    final r2 = size.height / 2;
    final x1 = (1 + cs) * r1;
    final y1 = (1 + sn) * r2;
    final x2 = r1 + cs * (r1 - _size);
    final y2 = r2 + sn * (r2 - _size);

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  static const origin = -pi / 2;
  static const _size = 16.0;
}
