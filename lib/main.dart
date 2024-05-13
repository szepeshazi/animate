import 'package:animate/bell/bell_animation.dart';
import 'package:animate/bouncing_ball/bouncing_ball.dart';
import 'package:animate/metaballs/meta_balls.dart';
import 'package:animate/shared/fps_widget.dart';
import 'package:animate/staggered/staggered_animation.dart';
import 'package:animate/v2.dart';
import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Compile the binary into a Fragment program.
  // final program = await FragmentProgram.compile(
  //   spirv: (await rootBundle.load('assets/shaders/exp.sprv')).buffer,
  // );
  //
  // // Turn it into a shader with given inputs (floatUniforms).
  // final Shader shader = program.shader(
  //   floatUniforms: Float32List.fromList(<double>[1]),
  // );
  //
  // debugPrint("Shader apparently loaded: ${shader.hashCode}");

  final dashbook = Dashbook();

  // Adds the Text widget stories
  dashbook
      .storiesOf('Animations')
      .add(
        "Gemini",
        (context) => const BellAnimation(),
      )
      .add(
    'Rotate',
    (_) {
      return const FPSWidget(
          alignment: Alignment.bottomRight, child: AnimationV2Widget());
    },
  ).add(
    'Meta balls',
    (dashContext) {
      return FPSWidget(
          alignment: Alignment.bottomRight,
          child: MetaBallsWidget(
              ballCount: dashContext.numberProperty('ball count', 8)));
    },
    info: 'Meta balls are implemented with CustomPainter using shaders.\n\n'
        'Each ball is drawn with a shader created from a RadialGradient, '
        'using white color values from fully opaque to fully transparent, '
        'on a specific curve.\n\n'
        'Shaders are added on top of each other using Blendmode.plus',
  ).add('Bouncing ball', (_) {
    //return BouncingBallWidget();
    return const FPSWidget(
        alignment: Alignment.bottomRight, child: BouncingBallWidget());
  }).add(
    'Staggered',
    (context) => const FPSWidget(
      alignment: Alignment.bottomRight,
      child: StaggerDemo(),
    ),
  );

  runApp(dashbook);
}
