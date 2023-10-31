import 'dart:async';

import 'package:flutter/material.dart';

/// A utility class that helps to implement debouncing behavior.
class Debouncer {
  /// Initializes a new [Debouncer].
  Debouncer({this.delay = const Duration(milliseconds: 300)});

  /// The delay between two calls.
  final Duration delay;

  Timer? _timer;

  /// Runs the [callback] after the [delay] has passed.
  ///
  /// When the delay hasn't passed yet and this method is called again, the
  /// previous call will be cancelled and a new call will be made.
  void run(VoidCallback callback) {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    _timer = Timer(delay, callback);
  }

  /// Closes the running timer.
  void dispose() {
    _timer?.cancel();
  }
}
