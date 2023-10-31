import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc_pattern_sample/core/extensions.dart';
import 'package:flutter_bloc_pattern_sample/weather/weather.dart';

class FakeCity extends Fake implements City {
  @override
  String get name => 'Abidjan';
}

void main() {
  final weather = Weather(
    city: FakeCity(),
    description: 'Light Rain',
    humidity: 12,
    pressure: 3,
    windSpeed: 12.1,
    applicableDate: DateTime.now(),
    temperature: const Temperature(value: 3),
    maxTemperature: const Temperature(value: 3),
    minTemperature: const Temperature(value: 3),
  );
  group('WeatherReportCard', () {
    testWidgets(
      'should show all the required weather data.',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: WeatherReportCard(weather: weather)),
          ),
        );
        await tester.idle();
        await tester.pump();

        expect(find.text(weather.applicableDate.readableDay), findsOneWidget);
        expect(find.text(weather.description), findsOneWidget);
        expect(find.text(weather.temperature.toString()), findsOneWidget);
        expect(find.text('Humidity: ${weather.humidity}%'), findsOneWidget);
        expect(find.text('Pressure: ${weather.pressure} hPa'), findsOneWidget);
      },
    );
  });
}
