import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';

import 'metaballs/meta_balls.dart';
import 'v2.dart';

void main() {
  final dashbook = Dashbook();

  // Adds the Text widget stories
  dashbook.storiesOf('Animations').add('Rotate', (_) {
    return const AnimationV2Widget();
  }).add(
    'Meta balls',
    (dashContext) {
      return MetaBallsWidget(ballCount: dashContext.numberProperty('ball count', 8));
    },
    info:
        'Meta balls are implemented with CustomPainter using shaders.\n\n'
            'Each ball is drawn with a shader created from a RadialGradient, '
            'using white color values from fully opaque to fully transparent, '
            'on a specific curve.\n\n'
            'Shaders are added on top of each other using Blendmode.plus',
  );

  runApp(dashbook);
}
