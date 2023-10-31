import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/metaweather_api.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/city.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/weather.dart';
import 'package:flutter_bloc_pattern_sample/weather/logic/weather_report_repository_impl.dart';

class MockWeatherAPI extends Mock implements MetaWeatherAPI {}

class FakeCity extends Fake implements City {}

class FakeWeather extends Fake implements Weather {}

void main() {
  late final WeatherReportRepositoryImpl subject;
  late final MetaWeatherAPI api;
  final cities = List<City>.filled(4, FakeCity());
  final weathers = List<Weather>.filled(6, FakeWeather());

  group('WeatherReportRepositoryImpl', () {
    setUpAll(() {
      api = MockWeatherAPI();
      subject = WeatherReportRepositoryImpl(api: api);
    });
    group('findCity()', () {
      setUp(() {
        when(() => api.searchCity(any<String>())).thenAnswer(
          (_) => Future<List<City>>.value(cities),
        );
      });
      test('should return a list of [City] objects', () async {
        await expectLater(
          await subject.findCity('paris'),
          isA<List<City>>(),
        );
      });
    });

    group('getWeatherReports()', () {
      setUp(() {
        registerFallbackValue(cities.first);
        when(() => api.getWeather(any<City>())).thenAnswer(
          (_) => Future<List<Weather>>.value(weathers),
        );
      });

      test('should return a list of [Weather] objects', () async {
        await expectLater(
          await subject.getWeatherReports(cities.first),
          isA<List<Weather>>(),
        );
      });
    });
  });
}
