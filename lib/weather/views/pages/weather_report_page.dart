import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_pattern_sample/weather/weather.dart';

part 'weather_report_page_horizontal_view.dart';
part 'weather_report_page_vertical_view.dart';

/// A page where the user can see the weather report of the selected city.
class WeatherReportPage extends StatefulWidget {
  /// Initializes a new [WeatherReportPage].
  const WeatherReportPage({Key? key}) : super(key: key);

  @override
  State<WeatherReportPage> createState() => _WeatherReportPageState();
}

class _WeatherReportPageState extends State<WeatherReportPage> {
  late final ValueNotifier<Weather?> _reportNotifier;

  @override
  void initState() {
    _reportNotifier = ValueNotifier<Weather?>(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WeatherReportCubit, WeatherReportState>(
        listener: (context, state) {
          if (state is WeatherReportFailure) {
            final cubit = context.read<WeatherReportCubit>();
            var message = 'Make sure you are connected to internet!';
            if (cubit.city == null) {
              message =
                  'Make sure you are connected to internet then select the city'
                  ' again';
            }
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Connexion Failed'),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (cubit.city != null) {
                        cubit.getReport(cubit.city!);
                      }
                      Navigator.of(context).pop();
                    },
                    child: cubit.city != null
                        ? const Text('Refresh')
                        : const Text('OK'),
                  )
                ],
              ),
            );
          }
        },
        buildWhen: (prev, current) => current is! SearchState,
        builder: (context, state) {
          if (state is WeatherReportLoaded) {
            _reportNotifier.value = state.report.first;
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: ()async{
                  await context
                      .read<WeatherReportCubit>()
                      .getReport(state.report.first.city);
                },
                child: ValueListenableBuilder<Weather?>(
                  valueListenable: _reportNotifier,
                  builder: (context, active, _) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth <= 426) {
                          return _VerticalView(
                            reportNotifier: _reportNotifier,
                            state: state,
                          );
                        }
                        return _HorizontalView(
                          reportNotifier: _reportNotifier,
                          state: state,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }
          if (state is WeatherReportLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(
            child: Text('Search a city to get the weather report'),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<WeatherReportCubit, WeatherReportState>(
            builder: (context, state) {
              return state is WeatherReportLoaded
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FloatingActionButton.small(
                        tooltip: 'Switch temperature unit',
                        backgroundColor: Colors.blueGrey,
                        onPressed: () {},
                        child: PopupMenuButton<TemperatureUnit>(
                          icon: const Icon(Icons.ac_unit),
                          itemBuilder: (context) => TemperatureUnit.values
                              .map(
                                (e) => PopupMenuItem<TemperatureUnit>(
                                  key: ValueKey<TemperatureUnit>(e),
                                  onTap: () {
                                    context
                                        .read<WeatherReportCubit>()
                                        .convertTempUnit(e);
                                  },
                                  child: Text(e.symbol),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          FloatingActionButton(
            tooltip: 'Open city search form',
            onPressed: _showSearchPage,
            child: const Icon(Icons.search),
          )
        ],
      ),
    );
  }

  Future<void> _showSearchPage() => showModalBottomSheet<void>(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => const SearchBottomSheet(),
      );

  @override
  void dispose() {
    _reportNotifier.dispose();
    super.dispose();
  }
}
