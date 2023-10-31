part of 'weather_report_cubit.dart';

/// Base type of states that can be emitted by [WeatherReportCubit].
abstract class WeatherReportState extends Equatable {
  /// Initializes a new [WeatherReportState].
  const WeatherReportState();

  @override
  List<Object?> get props => [];
}

/// Base type of states that can be emitted by [WeatherReportCubit] during
/// and after a search.
abstract class SearchState extends WeatherReportState {
  /// Initializes a new [SearchState].
  const SearchState();
}

/// Initial state.
class WeatherReportInitial extends WeatherReportState {}

/// State emitted when an operation is running and the data is no yet available.
class WeatherReportLoading extends WeatherReportState {}

/// State emitted when the city search results are loaded.
class SearchResultLoaded extends SearchState {
  /// Initializes a new [SearchResultLoaded].
  const SearchResultLoaded({required this.cities});

  /// Search results.
  final List<City> cities;

  @override
  List<Object?> get props => [cities];
}

/// State emitted when the city search is loading.
class SearchLoading extends SearchState {}

/// State emitted when the weather data has been loaded and is available.
///
/// This state would be emitted after the [SearchResultLoaded]
/// since it needs a city.
class WeatherReportLoaded extends WeatherReportState {
  /// Initializes a new [WeatherReportLoaded].
  const WeatherReportLoaded({required this.report});

  /// The loaded weather report.
  final List<Weather> report;

  @override
  List<Object> get props => [report];
}

/// State emitted when an error occurs while getting the data.
class WeatherReportFailure extends WeatherReportState {
  /// Initializes a new [WeatherReportFailure].
  const WeatherReportFailure({this.message});

  /// Error message.
  final String? message;

  @override
  List<Object?> get props => [message];
}

/// State emitted when an error occured while searching.
class SearchFailure extends WeatherReportFailure implements SearchState {
  /// Initializes a new [SearchFailure].
  const SearchFailure({String? message}) : super(message: message);
}
