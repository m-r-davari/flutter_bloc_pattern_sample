import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/metaweather_api.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/city.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/weather.dart';

class MockHttpClient extends Mock implements Client {}

class FakeURI extends Fake implements Uri {}

class FakeWeather extends Fake implements Weather {}

void main() {
  late final MetaWeatherAPI subject;
  late final Client httpClient;
  const cityData = {'title': 'Paris', 'latt_long': '12, 5', 'woeid': 1};
  final city = City.fromMap(cityData);
  final weatherData = {
    'consolidated_weather': [
      {
        'weather_state_name': 'Cloudy',
        'applicable_date': DateTime.now().toIso8601String(),
        'the_temp': 20,
        'wind_speed': 23,
        'air_pressure': 1023,
        'humidity': 54,
        'max_temp': 12,
        'min_temp': 8,
      }
    ]
  };

  group('MetaWeatherAPI', () {
    setUpAll(() {
      registerFallbackValue(FakeURI());
      registerFallbackValue(city);
      httpClient = MockHttpClient();
      subject = MetaWeatherAPI(client: httpClient);
    });

    group('searchCity', () {
      setUp(() {
        when(() => httpClient.get(any<Uri>())).thenAnswer(
          (_) async => Future<Response>.value(
            Response(json.encode([cityData]), 200),
          ),
        );
      });
      test('should return a list of cities', () async {
        final result = await subject.searchCity('paris');
        expect(result, isA<List<City>>());
        expect(result.contains(city), true);
        expect(result.length, 1);
      });

      test(
        'should throw a [HttpFailure] when an error occurs during the http '
        'request',
        () {
          when(() => httpClient.get(any<Uri>())).thenThrow(Exception());
          expect(
            () async => subject.searchCity('paris'),
            throwsA(isA<HttpFailure>()),
          );
        },
      );

      test(
        'should throw a [JSONDeserializationFailure] when deserializing a json'
        ' map into a model fails',
        () {
          when(() => httpClient.get(any<Uri>())).thenAnswer(
            (_) async => Future<Response>.value(
              Response(
                json.encode([
                  [
                    {'test': 'example'}
                  ]
                ]),
                200,
              ),
            ),
          );

          expect(
            () async => subject.searchCity('paris'),
            throwsA(isA<JSONDeserializationFailure>()),
          );
        },
      );
    });

    group('getWeather', () {
      setUp(() {
        when(() => httpClient.get(any<Uri>())).thenAnswer(
          (_) => Future<Response>.value(
            Response(json.encode(weatherData), 200),
          ),
        );
      });

      test('should return a list of weathers', () async {
        final result = await subject.getWeather(city);
        expect(result, isA<List<Weather>>());
      });

      test(
        'should throw a [HttpFailure] when an error occurs during the http '
        'request',
        () {
          when(() => httpClient.get(any<Uri>())).thenThrow(Exception());
          expect(
            () async => subject.getWeather(city),
            throwsA(isA<HttpFailure>()),
          );
        },
      );

      test(
        'should throw a [JSONDeserializationFailure] when deserializing a json'
        ' map into a model fails',
        () {
          when(() => httpClient.get(any<Uri>())).thenAnswer(
            (_) async => Future<Response>.value(
              Response(
                json.encode({
                  'consolidated_weather': [
                    {'example': 'Cloudy'}
                  ]
                }),
                200,
              ),
            ),
          );

          expect(
            () async => subject.getWeather(city),
            throwsA(isA<JSONDeserializationFailure>()),
          );
        },
      );
    });
  });
}
