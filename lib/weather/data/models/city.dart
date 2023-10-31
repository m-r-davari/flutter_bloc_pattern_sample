import 'package:equatable/equatable.dart';

/// A model that holds the data of a city.
class City with EquatableMixin {
  /// Initializes a new instance of [City].
  const City({
    required this.name,
    required this.latLong,
    required this.id,
  });

  /// Initializes a new instance of [City] from a given JSON Map.
  factory City.fromMap(Map<String, dynamic> jsonMap) => City(
        name: jsonMap['title'] as String,
        latLong: jsonMap['latt_long'] as String,
        id: (jsonMap['woeid'] as num).toInt(),
      );

  /// The name of the city.
  final String name;

  /// The coordinates of the city on the map.
  ///
  /// These coordinates correspond to the latitude and longitude; in this order.
  final String latLong;

  /// The city ID.
  final int id;

  @override
  List<Object?> get props => [name, latLong, id];
}
