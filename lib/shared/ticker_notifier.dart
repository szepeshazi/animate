import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class TickerNotifier implements ValueListenable<Duration> {
  @override
  Duration value = Duration.zero;

  final listeners = <VoidCallback>[];
  late Ticker? ticker;

  @override
  void addListener(VoidCallback listener) {
    if (listeners.isEmpty) {
      ticker = Ticker(_onTick);
      ticker!.start();
    }
    listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    listeners.remove(listener);
    if (listeners.isEmpty) {
      ticker?.stop();
      ticker = null;
    }
  }

  void _onTick(Duration elapsed) {
    value = elapsed;
    for (final callback in listeners) {
      callback();
    }
  }
}
