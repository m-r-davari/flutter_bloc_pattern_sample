import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc_pattern_sample/weather/weather.dart';

class MockWeatherRepository extends Mock implements IWeatherReportRepository {}

void main() {
  late final IWeatherReportRepository repository;
  late final WeatherReportCubit cubit;

  final cities = <City>[
    const City(name: 'Paris', latLong: '12.4, 5.2', id: 1),
    const City(name: 'London', latLong: '12.4, 5.2', id: 1),
  ];

  final weathers = List<Weather>.filled(
    2,
    Weather(
      city: cities.first,
      description: 'Light Rain',
      humidity: 12,
      applicableDate: DateTime.now(),
      maxTemperature: const Temperature(value: 12),
      minTemperature: const Temperature(value: 4),
      temperature: const Temperature(value: 7),
      pressure: 4,
      windSpeed: 3,
    ),
  );

  group('WeatherReportPage', () {
    setUpAll(() {
      registerFallbackValue(cities.first);
      repository = MockWeatherRepository();
      cubit = WeatherReportCubit(repository);

      when(() => repository.findCity(any<String>())).thenAnswer(
        (_) => Future<List<City>>.value(cities),
      );
      when(() => repository.getWeatherReports(any<City>())).thenAnswer(
        (_) => Future<List<Weather>>.value(weathers),
      );
    });

    testWidgets(
      'should show a centered text if the user has not selected a city yet',
      (tester) async {
        await tester.pumpWidget(_TestWeatherReportPage(cubit: cubit));
        await tester.idle();
        await tester.pump();

        expect(
          find.text('Search a city to get the weather report'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should only show one [FloatingActionButton] when the '
      'weather is not loaded yet.',
      (tester) async {
        await tester.pumpWidget(_TestWeatherReportPage(cubit: cubit));
        await tester.idle();
        await tester.pump();

        expect(find.byType(FloatingActionButton), findsOneWidget);
      },
    );

    testWidgets(
      'should show a [WeatherReportCard], multiple [MiniWeatherCard] and two '
      '[FloatingActionButton] when the weather data is loaded.',
      (tester) async {
        await cubit.getReport(cities.first);
        await tester.pumpWidget(_TestWeatherReportPage(cubit: cubit));
        await tester.idle();
        await tester.pump();

        expect(find.byType(WeatherReportCard), findsOneWidget);
        expect(find.byType(MiniReportCard), findsNWidgets(weathers.length));
        expect(find.byType(FloatingActionButton), findsNWidgets(2));
      },
    );
  });
}

class _TestWeatherReportPage extends StatelessWidget {
  const _TestWeatherReportPage({required this.cubit, Key? key})
      : super(key: key);

  final WeatherReportCubit cubit;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider.value(
        value: cubit,
        child: const WeatherReportPage(),
      ),
    );
  }
}
