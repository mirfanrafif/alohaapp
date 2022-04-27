import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/sales_provider.dart';
import '../../../data/response/statistics.dart';

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
          child: BarChart([
            Series<DailyReport, String>(
              id: 'Agent to customer Report',
              colorFn: (DailyReport report, _) =>
                  Color.fromHex(code: "#ffa600"),
              data: provider.statistics!.dailyReport ?? [],
              measureLowerBoundFn: (_, __) => 0,
              measureUpperBoundFn: (_, __) => 15,
              domainFn: (DailyReport report, _) {
                return report.date ?? "";
              },
              measureFn: (DailyReport report, _) => (report.average ?? 0) / 60,
            ),
          ]),
        ),
      ],
    );
  }
}

class CustomerUnreadMessagesChart extends StatelessWidget {
  final StatisticsResponse response;
  const CustomerUnreadMessagesChart({Key? key, required this.response})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: PieChart<String>(
        [
          Series<Statistics, String>(
            id: 'unread_messages',
            data: response.statistics!,
            domainFn: (Statistics current, index) => current.name ?? "",
            displayName: 'Jumlah pesan tidak terbaca berdasarkan customer',
            measureFn: (Statistics current, index) =>
                current.allUnreadMessageCount,
            colorFn: (Statistics current, _) {
              var statistics = response.statistics;
              var maxId = statistics!.map((e) => e.id).reduce(
                  (value, element) => element! > value! ? element : value);
              var currentId = current.id;

              var materialColor = Colors.primaries[
                  ((currentId! / maxId!) * Colors.primaries.length - 1)
                      .floor()];
              return Color(
                  r: materialColor.red,
                  g: materialColor.green,
                  b: materialColor.blue);
            },
          ),
        ],
        behaviors: [
          DatumLegend(
            showMeasures: true,
            position: BehaviorPosition.end,
            legendDefaultMeasure: LegendDefaultMeasure.firstValue,
          ),
        ],
      ),
    );
  }
}
