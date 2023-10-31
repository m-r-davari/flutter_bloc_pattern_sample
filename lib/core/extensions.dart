import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/metaweather_api.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/weather.dart';

/// An extension on [DateTime].
extension DateExtension on DateTime {
  /// Gets the day of this [DateTime] in a human readable format.
  String get readableDay => DateFormat.EEEE('en_US').format(this);

  /// Gets a short abbreviation of the day in this [DateTime].
  String get shortDay => DateFormat.E('en_US').format(this);
}

/// An extension on [BuildContext]
extension ContextX on BuildContext {
  /// The device's maximum screen size.
  Size get screenSize => MediaQuery.of(this).size;
}

/// An extension on [Weather].
extension WeatherX on Weather {
  /// The current weather's icon URL.
  String get weatherIconURL {
    final state = description.toLowerCase();
    if (state.contains('snow')) {
      return _getImageURL('/sn.png');
    }
    if (state.contains('sleet')) {
      return _getImageURL('/sl.png');
    }
    if (state.contains('hail')) {
      return _getImageURL('/h.png');
    }
    if (state.contains('thunderstorm')) {
      return _getImageURL('/t.png');
    }
    if (state.contains('heavy rain')) {
      return _getImageURL('/hr.png');
    }
    if (state.contains('light rain')) {
      return _getImageURL('/lr.png');
    }
    if (state.contains('showers')) {
      return _getImageURL('/s.png');
    }
    if (state.contains('heavy cloud')) {
      return _getImageURL('/hc.png');
    }
    if (state.contains('clear')) {
      return _getImageURL('/c.png');
    }
    return _getImageURL('/lc.png');
  }

  String _getImageURL(String path) {
    return 'https://${MetaWeatherAPI.authority}/static/img/weather/png$path';
  }
}
