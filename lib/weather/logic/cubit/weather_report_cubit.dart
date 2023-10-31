import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/city.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/weather.dart';
import 'package:flutter_bloc_pattern_sample/weather/logic/weather_report_repository.dart';

part 'weather_report_state.dart';

/// A [Cubit] that manages the state of weather report.
class WeatherReportCubit extends Cubit<WeatherReportState> {
  /// Initializes a new [WeatherReportCubit].
  WeatherReportCubit(IWeatherReportRepository repository)
      : _repository = repository,
        super(WeatherReportInitial());

  final IWeatherReportRepository _repository;

  /// Searches a city by its [name] and provides the search results in a
  /// [SearchResultLoaded] state.
  ///
  /// If an exception is thrown while fetching the data, a
  /// [WeatherReportFailure] will be emitted instead.
  Future<void> searchCity(String name) async {
    emit(SearchLoading());
    try {
      final result = await _repository.findCity(name);
      emit(SearchResultLoaded(cities: result));
    } catch (e, s) {
      addError(e, s);
      emit(SearchFailure(message: '$e'));
    }
  }

  /// Gets the weather report of the passed [city] and provides the data in a
  /// [WeatherReportLoaded] state.
  ///
  /// If an exception is thrown while fetching the data, a
  /// [WeatherReportFailure] will be emitted instead.
  Future<void> getReport(City city) async {
    emit(WeatherReportLoading());
    try {
      _city = city;
      final report = await _repository.getWeatherReports(city);
      emit(WeatherReportLoaded(report: report));
    } catch (e) {
      log('$e');
      emit(WeatherReportFailure(message: '$e'));
    }
  }

  /// Converts weather temperature unit into the passed [unit].
  void convertTempUnit(TemperatureUnit unit) {
    assert(
      state is WeatherReportLoaded,
      'Cannot change temperature unit without weather data',
    );
    final s = state as WeatherReportLoaded;
    final converted = s.report
        .map(
          (e) => e.copyWith(
            temperature: _convertTemperature(e.temperature, unit),
            minTemperature: _convertTemperature(e.minTemperature, unit),
            maxTemperature: _convertTemperature(e.maxTemperature, unit),
          ),
        )
        .toList();
    emit(WeatherReportLoaded(report: converted));
  }

  City? _city;

  /// The selected city.
  City? get city => _city;

  Temperature _convertTemperature(
    Temperature temperature,
    TemperatureUnit unit,
  ) {
    if (unit == temperature.unit) {
      return temperature;
    }
    var temp = temperature;
    if (unit == TemperatureUnit.celcius) {
      final value = (temp.value * 9 / 5) + 32;
      temp = temperature.copyWith(value: value, unit: unit);
    } else if (unit == TemperatureUnit.fahrenheit) {
      final value = (temp.value - 32) * 5 / 9;
      temp = temperature.copyWith(value: value, unit: unit);
    }
    return temp;
  }
}
