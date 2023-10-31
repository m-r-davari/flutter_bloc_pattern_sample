part of 'weather_report_page.dart';

class _VerticalView extends StatelessWidget {
  const _VerticalView({
    Key? key,
    required ValueNotifier<Weather?> reportNotifier,
    required this.state,
  })  : _reportNotifier = reportNotifier,
        super(key: key);

  final ValueNotifier<Weather?> _reportNotifier;

  final WeatherReportLoaded state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: WeatherReportCard(weather: _reportNotifier.value!),
          ),
          Expanded(
            child: SizedBox(
              height: 148,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  final weather = state.report[i];
                  return MiniReportCard(
                    weather: weather,
                    onTap: (w) {
                      _reportNotifier.value = w;
                    },
                  );
                },
                separatorBuilder: (context, _) => const SizedBox(
                  width: 16,
                ),
                itemCount: state.report.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
