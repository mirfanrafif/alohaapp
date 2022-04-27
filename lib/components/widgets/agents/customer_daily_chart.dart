import 'package:aloha/data/providers/sales_provider.dart';
import 'package:aloha/data/response/statistics.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgentCustomerDailyChart extends StatelessWidget {
  const AgentCustomerDailyChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, provider, child) => SizedBox(
        width: 500,
        height: provider.dailyReport!.responseTimes!.length * 25 + 50,
        child: BarChart(
          [
            Series<ResponseTimes, String>(
                id: 'Agent Customer Daily Report',
                data: provider.dailyReport!.responseTimes!,
                colorFn: (ResponseTimes times, _) {
                  if (times.seconds! > 600) {
                    return Color.fromHex(code: "#ff6361");
                  } else if (times.seconds! > 300) {
                    return Color.fromHex(code: "#ffa600");
                  } else {
                    return Color.fromHex(code: "#003f5c");
                  }
                },
                measureLowerBoundFn: (_, __) => 0,
                measureUpperBoundFn: (_, __) => 15,
                labelAccessorFn: (ResponseTimes times, _) {
                  var minutes = ((times.seconds ?? 0) / 60).round();
                  var seconds = ((times.seconds ?? 0) % 60).round();

                  return "$minutes menit\n$seconds detik";
                },
                domainFn: (ResponseTimes times, index) =>
                    index?.toString() ?? "",
                measureFn: (ResponseTimes times, index) =>
                    (times.seconds ?? 0) / 60),
          ],
          vertical: false,
          barRendererDecorator: BarLabelDecorator<String>(),
          domainAxis: const OrdinalAxisSpec(renderSpec: NoneRenderSpec()),
        ),
      ),
    );
  }
}
