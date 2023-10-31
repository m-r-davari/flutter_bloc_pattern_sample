import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/metaweather_api.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/city.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/weather.dart';
import 'package:flutter_bloc_pattern_sample/weather/logic/cubit/weather_report_cubit.dart';
import 'package:flutter_bloc_pattern_sample/weather/logic/weather_report_repository.dart';

class MockWeatherReportRepository extends Mock
    implements IWeatherReportRepository {}

class FakeCity extends Fake implements City {}

class FakeWeather extends Fake implements Weather {}

void main() {
  late final IWeatherReportRepository repository;
  final cities = List<City>.filled(4, FakeCity());
  final weathers = List<Weather>.filled(4, FakeWeather());

  group('WeatherReportCubit', () {
    setUpAll(() {
      registerFallbackValue(FakeCity());
      repository = MockWeatherReportRepository();
    });

    test('should emit a [WeatherReportInitial] state when initialized', () {
      final subject = WeatherReportCubit(repository);
      expect(subject.state, isA<WeatherReportInitial>());
      addTearDown(subject.close);
    });

    group('searchCity', () {
      setUp(() {
        when(() => repository.findCity(any<String>())).thenAnswer(
          (_) => Future<List<City>>.value(cities),
        );
      });
      blocTest<WeatherReportCubit, WeatherReportState>(
        'should get the search result and emit a [SearchResultLoaded]',
        build: () => WeatherReportCubit(repository),
        act: (cubit) => cubit.searchCity('paris'),
        expect: () => [isA<SearchLoading>(), isA<SearchResultLoaded>()],
      );

      blocTest<WeatherReportCubit, WeatherReportState>(
        'should emit a [SearchFailure] when an error occurs while getting data',
        build: () => WeatherReportCubit(repository),
        setUp: () {
          when(() => repository.findCity(any<String>())).thenThrow(
            const HttpFailure(),
          );
        },
        act: (cubit) => cubit.searchCity('paris'),
        expect: () => [isA<SearchLoading>(), isA<SearchFailure>()],
      );
    });

    group('getReport', () {
      setUp(() {
        when(() => repository.getWeatherReports(any<City>())).thenAnswer(
          (_) => Future<List<Weather>>.value(weathers),
        );
      });

      blocTest<WeatherReportCubit, WeatherReportState>(
        'should emit a [WeatherReportLoaded] state with the loaded report.',
        build: () => WeatherReportCubit(repository),
        act: (cubit) => cubit.getReport(FakeCity()),
        expect: () => [isA<WeatherReportLoading>(), isA<WeatherReportLoaded>()],
      );

      blocTest<WeatherReportCubit, WeatherReportState>(
        'should emit a [WeatherReportFailure] when an error occurs while '
        'fetching the data.',
        build: () => WeatherReportCubit(repository),
        setUp: () {
          when(() => repository.getWeatherReports(any<City>())).thenThrow(
            const HttpFailure(),
          );
        },
        act: (cubit) => cubit.getReport(FakeCity()),
        expect: () => [
          isA<WeatherReportLoading>(),
          isA<WeatherReportFailure>(),
        ],
      );

      group('convertTempUnit', () {
        blocTest<WeatherReportCubit, WeatherReportState>(
          '',
          build: () => WeatherReportCubit(repository),
          act: (cubit) {
            cubit
              ..emit(
                WeatherReportLoaded(
                  report: [
                    Weather(
                      city: FakeCity(),
                      description: 'description',
                      humidity: 45,
                      pressure: 34,
                      windSpeed: 9,
                      applicableDate: DateTime.now(),
                      temperature: const Temperature(value: 12),
                      maxTemperature: const Temperature(value: 12),
                      minTemperature: const Temperature(value: 12),
                    )
                  ],
                ),
              )
              ..convertTempUnit(TemperatureUnit.fahrenheit);
          },
          expect: () => [
            isA<WeatherReportLoaded>(),
            isA<WeatherReportLoaded>(),
          ],
        );
      });
    });
  });
}
