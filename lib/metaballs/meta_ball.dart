import 'dart:math';

import 'package:flutter/material.dart';

class MetaBall {
  final Size canvasSize;
  late double radius;
  late double x;
  late double y;
  late double dx;
  late double dy;

  Offset get center => Offset(x, y);

  MetaBall(this.canvasSize) {
    final rnd = Random();
    radius = max(canvasSize.width, canvasSize.height * radiusMultiplier);
    x = rnd.nextDouble() * canvasSize.width;
    y = rnd.nextDouble() * canvasSize.height;
    dx = rnd.nextDouble() * speed - speed / 2;
    dy = rnd.nextDouble() * speed - speed / 2;
  }

  void move() {
    x += dx;
    if (x < 0 || x > canvasSize.width) {
      dx = -dx;
      x += dx;
    }
    y += dy;
    if (y < 0 || y > canvasSize.height) {
      dy = -dy;
      y += dy;
    }
  }

  static const speed = 10.0;
  static const radiusMultiplier = 0.75;
}
