import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_pattern_sample/weather/weather.dart';

/// The head of the app widgets tree.
class App extends StatelessWidget {
  /// Initializes a new [App].
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = context.read<IWeatherReportRepository>();
    return BlocProvider<WeatherReportCubit>(
      create: (context) => WeatherReportCubit(repository),
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherReportPage(),
    );
  }
}
