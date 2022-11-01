import 'package:flutter/material.dart';

class AnimationProps {
  final Color? color;

  final BorderRadius? borderRadius;

  final double? width;

  final double? height;

  final Matrix4? transform;

  const AnimationProps({this.color, this.borderRadius, this.width, this.height, this.transform});
}

Stream<AnimationProps> animStream() async* {
  double velocity = 0.0;
  double angle = 0.0;
  const animSteps = 300;
  int opacity = 0;
  double size = 0;
  for (int i = 0; i < animSteps; i++) {
    if (i < animSteps / 2) {
      opacity = (i * 255 / (animSteps / 2)).floor();
      size = i * 120 / (animSteps / 2);
    } else {
      opacity = 255;
      size = 120;
    }

    yield AnimationProps(
      color: Color.fromARGB(opacity, 255, 0, 0),
      transform: Matrix4.rotationZ(angle),
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 4),
    );
    if (i < animSteps / 2) {
      velocity += 0.003;
    } else {
      velocity -= 0.003;
    }
    angle += velocity;
  }

  yield AnimationProps(
    transform: Matrix4.rotationZ(0),
  );
}
