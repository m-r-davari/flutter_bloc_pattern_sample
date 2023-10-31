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

  group('SearchBottomSheet', () {
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

    testWidgets('should show an input field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const Scaffold(body: SearchBottomSheet()),
          ),
        ),
      );
      await tester.idle();
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter a city name'), findsOneWidget);
    });

    testWidgets(
      'should search cities when the user enters text.',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cubit,
              child: const Scaffold(body: SearchBottomSheet()),
            ),
          ),
        );
        await tester.idle();
        await tester.pump();

        await tester.enterText(find.byType(EditableText), 'paris');
        // Pumping `500 ms` to wait for the debounce.
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(ListTile), findsNWidgets(cities.length));
        for (final city in cities) {
          expect(find.text(city.name), findsOneWidget);
        }
      },
    );
  });
}
