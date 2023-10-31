part of 'weather_report_page.dart';

class _HorizontalView extends StatelessWidget {
  const _HorizontalView({
    Key? key,
    required ValueNotifier<Weather?> reportNotifier,
    required this.state,
  })  : _reportNotifier = reportNotifier,
        super(key: key);

  final ValueNotifier<Weather?> _reportNotifier;

  final WeatherReportLoaded state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: WeatherReportCard(weather: _reportNotifier.value!)),
        const VerticalDivider(
          color: Colors.grey,
          thickness: 0,
          width: 1,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: GridView.builder(
              gridDelegate:
                  // ignore: lines_longer_than_80_chars
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 24,
              ),
              itemBuilder: (context, i) {
                final weather = state.report[i];
                return MiniReportCard(
                  weather: weather,
                  onTap: (w) {
                    _reportNotifier.value = w;
                  },
                );
              },
              itemCount: state.report.length,
            ),
          ),
        )
      ],
    );
  }
}
