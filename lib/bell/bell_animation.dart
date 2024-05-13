import 'dart:math' as math;

import 'package:flutter/material.dart';

class BellAnimation extends StatefulWidget {
  const BellAnimation({super.key});

  @override
  State<BellAnimation> createState() => _BellAnimationState();
}

class _BellAnimationState extends State<BellAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );

  late final Animation<double> _bellAnimation =
      Tween<double>(begin: -0.05, end: 0.05).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  int cycles = 0;
  bool lastRound = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _controller.addStatusListener((status) {
      if (const [AnimationStatus.completed].contains(status)) {
        cycles++;
      }
      if (cycles < _repeats) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
          if (cycles == _repeats - 1) {
            lastRound = true;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        var angle = calculateAngle();
        return Transform.rotate(
          angle: angle,
          origin: const Offset(0, -BellIcon.iconSize / 2),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            cycles = 0;
            lastRound = false;
            _controller.reset();
          });
        },
        child: const BellIcon(),
      ),
    );
  }

  double calculateAngle() {
    var angle =
        (_bellAnimation.value * math.pi * 6) / (math.pow(cycles + 1, 1.7));
    if (lastRound && angle > 0) {
      angle = 0;
    }
    return angle;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const _repeats = 5;
}

class BellIcon extends StatelessWidget {
  const BellIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.notifications,
              size: iconSize,
              color: Colors.orange,
            ),
            Positioned(
              bottom: 3,
              child: BellClapper(
                bellSize: iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const iconSize = 50.0;
}

class BellClapper extends StatefulWidget {
  const BellClapper({super.key, required this.bellSize})
      : width = bellSize * 0.5,
        height = bellSize * 0.15;

  final double bellSize;
  final double width;
  final double height;

  @override
  State<BellClapper> createState() => _BellClapperState();
}

class _BellClapperState extends State<BellClapper> {
  var offset = 0.5;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: BellClapperPainter(
        bellSize: widget.bellSize,
        width: widget.width,
        height: widget.height,
        offset: offset,
      ),
    );
  }
}

class BellClapperPainter extends CustomPainter {
  BellClapperPainter({
    super.repaint,
    required this.bellSize,
    required this.width,
    required this.height,
    required this.offset,
  });

  final double bellSize;
  final double width;
  final double height;
  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    // Covering the original bell clapper with a white stripe
    final maskPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    canvas.drawRect(Rect.fromLTRB(0, 0, width, height), maskPaint);

    // Draw the bell clapper
    final rect = Rect.fromCenter(
      center: Offset(width * offset, height / 4),
      height: height,
      width: height,
    );
    const startAngle = math.pi;
    const sweepAngle = -math.pi;
    const useCenter = false;

    final arcPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, arcPaint);
  }

  @override
  bool shouldRepaint(BellClapperPainter oldDelegate) {
    return oldDelegate.bellSize != bellSize ||
        oldDelegate.offset != offset ||
        oldDelegate.width != width ||
        oldDelegate.height != height;
  }
}
