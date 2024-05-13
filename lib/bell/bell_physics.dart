import 'dart:math' as math;

import 'package:flutter/animation.dart';

class SwingingBellTween extends Tween<BellPosition> {
  SwingingBellTween({
    this.initialPosition = -math.pi / 2,
    this.initialSwingEnd = 0,
    this.numOfSwings = 6,
  }) : assert(numOfSwings > 1);

  final double initialPosition;
  final double initialSwingEnd;
  final int numOfSwings;


  void calcTweens() {
    var start = initialPosition;
    var end = initialSwingEnd;
    //final first = Tween(begin: start, end: end);
    for (var i = 0; i < numOfSwings; i++) {
      start = end;
      if (i == numOfSwings -1) {
        end = 0;
      } else {
        end = -math.pow(start, (1 / (i+1))).toDouble();
      }
    }
  }

  @override
  BellPosition lerp(double t) {
    return const BellPosition(angle: 0, clapperOffset: 0);
  }

}

class BellPosition {
  const BellPosition({
    required this.angle,
    required this.clapperOffset,
  });

  final double angle;
  final double clapperOffset;
}
