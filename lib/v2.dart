import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'animator.dart';

class AnimationV2Widget extends StatefulWidget {
  const AnimationV2Widget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnimationV2WidgetState();
  }
}

class _AnimationV2WidgetState extends State<AnimationV2Widget> {
  final List<AnimationProps> steps = [];
  late final Ticker _ticker;
  late StreamSubscription<AnimationProps> sub;
  AnimationProps step = const AnimationProps();

  @override
  void initState() {
    super.initState();
    sub = animStream().listen((step) {
      steps.add(step);
    });
    _ticker = Ticker(_update);
    _ticker.start();
  }

  void _update(Duration elapsed) {
    setState(() {
      if (steps.isNotEmpty) {
        step = steps.removeAt(0);
      } else {
        _ticker.stop();
      }
    });
  }

  Future<void> _restart() async {
    _ticker.stop();
    sub.cancel();
    steps.clear();
    sub = animStream().listen((step) {
      steps.add(step);
    });
    await Future<void>.delayed(Duration.zero);
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          _restart();
        },
        child: Container(
          decoration: BoxDecoration(
              color: step.color ?? Colors.red,
              borderRadius: step.borderRadius ?? BorderRadius.circular(30)),
          width: step.width ?? 120,
          height: step.height ?? 120,
          transform: step.transform ?? Matrix4.identity(),
          transformAlignment: Alignment.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
