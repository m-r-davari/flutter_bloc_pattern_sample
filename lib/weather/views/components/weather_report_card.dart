import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern_sample/core/extensions.dart';
import 'package:flutter_bloc_pattern_sample/weather/weather.dart';

/// A card that displays the main weather report.
class WeatherReportCard extends StatelessWidget {
  /// Initializes a new [WeatherReportCard]
  const WeatherReportCard({required this.weather, Key? key}) : super(key: key);

  /// The weather data displayed in this widget.
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: kToolbarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    weather.applicableDate.readableDay,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '(${weather.city.name})',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  Text(
                    weather.description,
                    style: Theme.of(context).textTheme.button,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: CachedNetworkImage(
              imageUrl: weather.weatherIconURL,
              placeholder: (context, _) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '${weather.temperature}',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: Text('Humidity: ${weather.humidity}%')),
                Expanded(child: Text('Pressure: ${weather.pressure} hPa')),
                Expanded(
                  child: Text(
                    'Wind: ${weather.windSpeed.toStringAsFixed(3)} KM/H',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
