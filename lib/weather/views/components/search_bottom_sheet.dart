import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_pattern_sample/core/debouncer.dart';
import 'package:flutter_bloc_pattern_sample/weather/weather.dart';

/// A Bottom sheet that provides an input where the user can search
/// a city by its name.
class SearchBottomSheet extends StatefulWidget {
  /// Initializes a new [SearchBottomSheet]
  const SearchBottomSheet({Key? key}) : super(key: key);

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final _searchDebouncer = Debouncer();
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Search City by name',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (text) {
              if (text.isNotEmpty) {
                _searchDebouncer.run(
                  () {
                    context.read<WeatherReportCubit>().searchCity(text);
                  },
                );
              }
            },
          ),
          Expanded(
            child: BlocBuilder<WeatherReportCubit, WeatherReportState>(
              builder: (context, state) {
                if (state is SearchResultLoaded) {
                  if (state.cities.isNotEmpty) {
                    return SizedBox(
                      height: 125,
                      child: ListView.separated(
                        itemBuilder: (context, i) {
                          final city = state.cities[i];
                          return ListTile(
                            onTap: () {
                              context
                                  .read<WeatherReportCubit>()
                                  .getReport(city);
                              Navigator.of(context).pop();
                            },
                            title: Text(city.name),
                          );
                        },
                        separatorBuilder: (context, _) => const Divider(
                          endIndent: 16,
                          indent: 16,
                          color: Colors.grey,
                        ),
                        itemCount: state.cities.length,
                      ),
                    );
                  }
                  return Center(
                    child: Text('No result found for ${_controller.text}'),
                  );
                }
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const Center(child: Text('Enter a city name'));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    _controller.dispose();
    super.dispose();
  }
}
