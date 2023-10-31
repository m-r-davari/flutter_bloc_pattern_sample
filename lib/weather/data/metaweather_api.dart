import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_bloc_pattern_sample/weather/data/models/city.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/weather.dart';

/// A class that handles API calls to the [MetaWeather API](https://www.metaweather.com/).
class MetaWeatherAPI {
  /// Initializes a new instance of [MetaWeatherAPI].
  MetaWeatherAPI({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Base path of the API.
  static const authority = 'www.metaweather.com';

  /// Searches a city by its [name].
  Future<List<City>> searchCity(String name) async {
    final data = await _get(
      path: '/api/location/search',
      queryParams: <String, dynamic>{'query': name},
    ) as List;
    try {
      return data
          .map((dynamic e) => City.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw JSONDeserializationFailure(message: '$e');
    }
  }

  /// Gets the weather of the passed [city].
  Future<List<Weather>> getWeather(City city) async {
    final data = await _get(
      path: '/api/location/${city.id}',
    ) as Map<String, dynamic>;

    final weatherData = data['consolidated_weather'] as List;
    try {
      return weatherData
          .map((dynamic e) => Weather.fromMap(e as Map<String, dynamic>, city))
          .toList();
    } catch (e) {
      throw JSONDeserializationFailure(message: '$e');
    }
  }

  Future<dynamic> _get({
    required String path,
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.https(authority, path, queryParams);

    late final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 5));
    } catch (e) {
      throw HttpFailure(message: '$e');
    }

    if (response.statusCode >= 300 || response.statusCode < 200) {
      throw Non200StatusCode(statusCode: response.statusCode);
    }

    late final dynamic data;
    try {
      data = json.decode(response.body);
    } catch (e) {
      throw JSONDecodeFailure(message: '$e');
    }
    return data;
  }
}

/// Base exception that can be thrown by [MetaWeatherAPI].
abstract class WeatherException implements Exception {
  /// Initializes a new [WeatherException].
  const WeatherException({this.message});

  /// The error message.
  final String? message;

  @override
  String toString() => '$runtimeType($message)';
}

/// Exception thrown when an error occurs during the http request.
class HttpFailure extends WeatherException {
  /// Initializes a new [HttpFailure].
  const HttpFailure({String? message}) : super(message: message);
}

/// Exception thrown when decoding the json fails.
class JSONDecodeFailure extends WeatherException {
  /// Initializes a new [JSONDecodeFailure].
  const JSONDecodeFailure({String? message}) : super(message: message);
}

/// Exception thrown when deserializing a json Map into a model fails.
class JSONDeserializationFailure extends WeatherException {
  /// Initializes a new [JSONDeserializationFailure].
  const JSONDeserializationFailure({String? message}) : super(message: message);
}

/// Exception thwon when the request gives a response with a non-200 status code
class Non200StatusCode extends WeatherException {
  /// Initializes a new [Non200StatusCode].
  const Non200StatusCode({required this.statusCode, String? message})
      : super(message: message);

  /// The status code.
  final int statusCode;

  @override
  String? get message => super.message ?? 'Status $statusCode';
}
