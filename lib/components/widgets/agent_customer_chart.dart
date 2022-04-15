import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/sales_provider.dart';
import '../../data/response/statistics.dart';

class AgentStatisticsCustomerChart extends StatelessWidget {
  const AgentStatisticsCustomerChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SalesProvider>(context);
    return Column(
      children: [
        Text("Waktu respon per-hari dengan customer " +
            (provider.statistics!.name ?? "")),
        SizedBox(
          width: 500,
          height: 200,
          child: TimeSeriesChart([
            Series<DailyReport, DateTime>(
              id: 'Agent to customer Report',
              colorFn: (DailyReport report, _) =>
                  Color.fromHex(code: "#ffa600"),
              data: provider.statistics!.dailyReport ?? [],
              measureLowerBoundFn: (_, __) => 0,
              measureUpperBoundFn: (_, __) => 15,
              domainFn: (DailyReport report, _) {
                var dateSplit = report.date?.split('/');
                return DateTime(
                  int.parse(dateSplit?[2] ?? "0"),
                  int.parse(dateSplit?[1] ?? "1"),
                  int.parse(dateSplit?[0] ?? "1"),
                );
              },
              measureFn: (DailyReport report, _) => (report.average ?? 0) / 60,
            ),
          ]),
        ),
      ],
    );
  }
}
