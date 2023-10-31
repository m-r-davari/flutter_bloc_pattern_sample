import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_pattern_sample/app.dart';
import 'package:flutter_bloc_pattern_sample/weather/weather.dart';

void main() {
  final weatherReportRepository = WeatherReportRepositoryImpl(
    api: MetaWeatherAPI(),
  );

  BlocOverrides.runZoned(
    blocObserver: CoreBlocObserver(),
        () => runApp(
      RepositoryProvider<IWeatherReportRepository>.value(
        value: weatherReportRepository,
        child: const App(),
      ),
    ),
  );
}

/// A [BlocObserver] that observes all core blocs.
class CoreBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('${bloc.runtimeType}($error)\n$stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
