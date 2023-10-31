import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/city.dart';

/// A model that holds the weather data.
class Weather with EquatableMixin {
  /// Initializes a new instance of [Weather].
  const Weather({
    required this.city,
    required this.description,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.applicableDate,
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
  });

  /// Initializes a new [City] object from a JSON Map.
  ///
  /// Requires the [city] to be passed.
  factory Weather.fromMap(Map<String, dynamic> jsonMap, City city) {
    // converting wind speed to KM/H because the API gives the value
    // in Miles per hour.
    final speed = (jsonMap['wind_speed'] as num).toDouble() * 1.609;
    return Weather(
      city: city,
      description: jsonMap['weather_state_name'] as String,
      humidity: (jsonMap['humidity'] as num).toDouble(),
      pressure: (jsonMap['air_pressure'] as num).toDouble(),
      windSpeed: speed,
      applicableDate: DateTime.parse(jsonMap['applicable_date'] as String),
      temperature: Temperature(value: jsonMap['the_temp'] as num),
      maxTemperature: Temperature(value: jsonMap['max_temp'] as num),
      minTemperature: Temperature(value: jsonMap['min_temp'] as num),
    );
  }

  /// The city this weather is from.
  final City city;

  /// The weather state description.
  ///
  /// `Eg: Cloudy, Sunny, Light Rain`
  final String description;

  /// The wind speed in KM/H.
  final double windSpeed;

  /// The humidity percentage.
  final double humidity;

  /// The pressure value in mbar/hPa.
  final double pressure;

  /// The temperature in Celcius.
  final Temperature temperature;

  /// Minimum temperature.
  final Temperature minTemperature;

  /// Maximum temperature.
  final Temperature maxTemperature;

  /// The date when this [Weather] will be observed.
  final DateTime applicableDate;

  @override
  List<Object?> get props => [
        city,
        description,
        windSpeed,
        humidity,
        pressure,
        temperature,
        applicableDate,
        minTemperature,
        maxTemperature,
      ];

  /// Uses the current [Weather] object as a prototype to generates a new one.
  Weather copyWith({
    City? city,
    String? description,
    double? humidity,
    double? pressure,
    double? windSpeed,
    DateTime? applicableDate,
    Temperature? temperature,
    Temperature? minTemperature,
    Temperature? maxTemperature,
  }) =>
      Weather(
        city: city ?? this.city,
        description: description ?? this.description,
        humidity: humidity ?? this.humidity,
        pressure: pressure ?? this.pressure,
        windSpeed: windSpeed ?? this.windSpeed,
        applicableDate: applicableDate ?? this.applicableDate,
        temperature: temperature ?? this.temperature,
        minTemperature: minTemperature ?? this.minTemperature,
        maxTemperature: maxTemperature ?? this.maxTemperature,
      );
}

/// A model that holds the temperature data.
class Temperature with EquatableMixin {
  /// Initializes a new [Temperature].
  const Temperature({required this.value, this.unit = TemperatureUnit.celcius});

  /// The value of the temperature.
  final num value;

  /// The temperature unit.
  final TemperatureUnit unit;

  @override
  List<Object?> get props => [value, unit];

  @override
  String toString() => '${value.toStringAsFixed(1)} ${unit.symbol}';

  /// Uses the current [Temperature] object as a prototype to generates a new
  /// one.
  Temperature copyWith({num? value, TemperatureUnit? unit}) => Temperature(
        value: value ?? this.value,
        unit: unit ?? this.unit,
      );
}

/// Unit of [Temperature]
enum TemperatureUnit {
  /// Celcius
  celcius,

  /// Fahrenheit
  fahrenheit
}

/// An extension on [TemperatureUnit].
extension TemperatureUnitX on TemperatureUnit {
  /// Gets the symbol of the unit.
  String get symbol {
    switch (this) {
      case TemperatureUnit.celcius:
        return '°C';
      case TemperatureUnit.fahrenheit:
        return '°F';
    }
  }
}
