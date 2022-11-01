import 'dart:math';

import 'package:animate/metaballs/ticker_notifier.dart';
import 'package:flutter/material.dart';

import 'meta_ball.dart';

class MetaBallsWidget extends StatelessWidget {
  const MetaBallsWidget({super.key, required this.ballCount});

  final num ballCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomPaint(
        painter: MetaBallsPainter(TickerNotifier(), ballCount.toInt()),
        child: const SizedBox(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class MetaBallsPainter extends CustomPainter {
  MetaBallsPainter(this.tickerNotifier, this.ballCount) : super(repaint: tickerNotifier) {
    tickerNotifier.addListener(() {
      elapsed = tickerNotifier.value;
    });
  }

  final int ballCount;


  Duration elapsed = Duration.zero;
  final TickerNotifier tickerNotifier;
  List<MetaBall>? _balls;
  List<Color>? _gradient;
  List<Color>? _colors;
  List<double>? steps;

  static const stopCount = 10;

  @override
  void paint(Canvas canvas, Size size) {
    _balls ??= List<MetaBall>.generate(ballCount, (_) => MetaBall(size));
    _gradient ??= List<Color>.generate(
      stopCount,
      (index) => Color.fromARGB((pow((stopCount - index) / stopCount, 2) * 255).toInt(), 255, 255, 255),
    );
    _colors ??= [
      ...List.generate((stopCount / 2).floor(), (_) => Colors.white),
      ..._gradient!,
      ...List.generate(stopCount, (_) => const Color(0x00ffffff)),
    ];

    for (final ball in _balls!) {
      ball.move();
      final paint = Paint()
        ..shader = RadialGradient(
          colors: _colors!,
        ).createShader(
          Rect.fromCenter(
            center: ball.center,
            width: ball.radius,
            height: ball.radius,
          ),
        )
        ..blendMode = BlendMode.plus;
      canvas.drawPaint(paint);
    }
  }

  @override
  bool shouldRepaint(MetaBallsPainter oldDelegate) {
    return oldDelegate.elapsed.inSeconds != elapsed.inSeconds;
  }
}
