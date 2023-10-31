import 'package:flutter_bloc_pattern_sample/weather/data/metaweather_api.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/city.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/weather.dart';
import 'package:flutter_bloc_pattern_sample/weather/logic/weather_report_repository.dart';

/// An implementation of [IWeatherReportRepository] that uses [MetaWeatherAPI]
/// as a data source.
class WeatherReportRepositoryImpl implements IWeatherReportRepository {
  /// Initializes a new [WeatherReportRepositoryImpl].
  const WeatherReportRepositoryImpl({required MetaWeatherAPI api}) : _api = api;
  final MetaWeatherAPI _api;

  @override
  Future<List<City>> findCity(String name) => _api.searchCity(name);

  @override
  Future<List<Weather>> getWeatherReports(City city) => _api.getWeather(city);
}
