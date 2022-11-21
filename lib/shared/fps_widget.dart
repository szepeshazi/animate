import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

extension _FPS on Duration {
  double get fps => (1000 / inMilliseconds);
}

/// A widget that shows the current FPS.
class FPSWidget extends StatefulWidget {
  final Widget child;

  /// Where the [FPSWidget] should be positioned.
  final Alignment alignment;

  /// Whether to show the [FPSWidget].
  /// ```dart
  /// FpsWidget(
  ///   show: !kReleaseMode,
  ///   child: MyHomePage(),
  /// )
  /// ```
  final bool show;

  const FPSWidget({
    Key? key,
    required this.child,
    this.show = true,
    this.alignment = Alignment.topRight,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FPSWidgetState createState() => _FPSWidgetState();
}

class _FPSWidgetState extends State<FPSWidget> {
  Duration? prev;
  List<Duration> timings = [];
  double width = 150;
  double height = 100;
  late int framesToDisplay = width ~/ 5;
  int frameCounter = 0;
  double avgFPS = 0;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(_update);
    super.initState();
  }

  void _update(Duration duration) {
    if (mounted) {
      setState(() {
        if (prev != null) {
          timings.add(duration - prev!);
          if (timings.length > framesToDisplay) {
            timings = timings.sublist(timings.length - framesToDisplay - 1);
          }
        }
        prev = duration;
        frameCounter = (++frameCounter) % framesToDisplay;
      });

      if (widget.show) {
        SchedulerBinding.instance.addPostFrameCallback(_update);
      }
    }
  }

  @override
  void didUpdateWidget(covariant FPSWidget oldWidget) {
    if (oldWidget.show && !widget.show) {
      prev = null;
    }

    if (!oldWidget.show && widget.show) {
      SchedulerBinding.instance.addPostFrameCallback(_update);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final current = timings.isNotEmpty ? timings.last.fps.toStringAsFixed(0) : '';
    if (frameCounter == 0) {
      avgFPS = timings.isNotEmpty
          ? (timings.map((e) => e.fps).reduce((value, element) => value + element) / timings.length)
          : 0;
    }
    return Stack(
      alignment: widget.alignment,
      children: [
        widget.child,
        if (widget.show)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: height,
              width: width + 17,
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: const Color(0x80000000),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (timings.isNotEmpty) ...[
                    Text(
                      'FPS current: $current',
                      style: const TextStyle(color: Color(0xffffffff)),
                    ),
                    Text(
                      'FPS avg: ${avgFPS.toStringAsFixed(0)}',
                      style: const TextStyle(color: Color(0xffffffff)),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Expanded(
                    child: SizedBox(
                      width: width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ...timings.map((timing) {
                            final p = (timing.fps / 60).clamp(0.0, 1.0);

                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 1.0,
                              ),
                              child: Container(
                                color: Color.lerp(
                                  const Color(0xbbf44336),
                                  const Color(0xbb4caf50),
                                  p,
                                ),
                                width: 4,
                                height: p * height,
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
