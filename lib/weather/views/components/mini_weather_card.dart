import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern_sample/core/extensions.dart';
import 'package:flutter_bloc_pattern_sample/weather/data/models/weather.dart';

/// A small card that holds the weather report for a specific day.
class MiniReportCard extends StatelessWidget {
  /// Initializes a new [MiniReportCard].
  const MiniReportCard({
    required this.weather,
    Key? key,
    required this.onTap,
  }) : super(key: key);

  /// The weather on this card.
  final Weather weather;

  /// Callback called when this widget is tapped.
  final void Function(Weather) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () => onTap(weather),
        child: Material(
          elevation: 4,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 120,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    weather.applicableDate.shortDay,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CachedNetworkImage(
                        imageUrl: weather.weatherIconURL,
                        placeholder: (context, _) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${weather.minTemperature} / ${weather.maxTemperature}',
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
