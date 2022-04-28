import 'package:charts_flutter/flutter.dart' as charts;
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
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width:
                    (provider.statistics!.dailyReport?.length ?? 0) * 70 + 50,
                height: 200,
                child: charts.BarChart([
                  charts.Series<DailyReport, String>(
                    id: 'Agent to customer Report',
                    colorFn: (DailyReport report, _) {
                      var materialColor = Colors.cyan;
                      return charts.Color(
                          r: materialColor.red,
                          g: materialColor.green,
                          b: materialColor.blue);
                    },
                    data: provider.statistics!.dailyReport ?? [],
                    measureLowerBoundFn: (_, __) => 0,
                    measureUpperBoundFn: (_, __) => 15,
                    domainFn: (DailyReport report, _) {
                      return report.date ?? "";
                    },
                    labelAccessorFn: (DailyReport report, _) =>
                        ((report.average ?? 0) / 60).round().toString() +
                        " menit",
                    measureFn: (DailyReport report, _) =>
                        (report.average ?? 0) / 60,
                  ),
                ], barRendererDecorator: charts.BarLabelDecorator<String>()),
              )
            ],
          ),
        )
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
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: (response.statistics?.length ?? 0) * 70 + 50,
            height: 100,
            child: charts.BarChart(
              [
                charts.Series<Statistics, String>(
                  id: 'read_messages',
                  data: response.statistics!,
                  domainFn: (Statistics current, index) => current.name ?? "",
                  displayName: 'Jumlah pesan terbaca',
                  measureFn: (Statistics current, index) {
                    List<ResponseTimes> responseTimes = [];
                    current.dailyReport?.forEach((element) {
                      if (element.responseTimes != null) {
                        responseTimes.addAll(element.responseTimes!);
                      }
                    });
                    return responseTimes.length;
                  },
                  labelAccessorFn: (Statistics current, _) {
                    List<ResponseTimes> responseTimes = [];
                    current.dailyReport?.forEach((element) {
                      if (element.responseTimes != null) {
                        responseTimes.addAll(element.responseTimes!);
                      }
                    });
                    return responseTimes.length.toString();
                  },
                  colorFn: (Statistics current, _) {
                    var materialColor = Colors.lightGreen;
                    return charts.Color(
                        r: materialColor.red,
                        g: materialColor.green,
                        b: materialColor.blue);
                  },
                ),
                charts.Series<Statistics, String>(
                    id: 'unread_messages',
                    data: response.statistics!,
                    domainFn: (Statistics current, index) => current.name ?? "",
                    displayName: 'Jumlah pesan tidak terbaca',
                    measureFn: (Statistics current, index) =>
                        current.allUnreadMessageCount,
                    colorFn: (Statistics current, _) {
                      var materialColor = Colors.orange;
                      return charts.Color(
                          r: materialColor.red,
                          g: materialColor.green,
                          b: materialColor.blue);
                    },
                    labelAccessorFn: (Statistics current, index) =>
                        current.allUnreadMessageCount.toString()),
              ],
              behaviors: [charts.SeriesLegend()],
              barRendererDecorator: charts.BarLabelDecorator<String>(),
            ),
          )
        ],
      ),
    );
  }
}

class CustomerResponseTimesChart extends StatelessWidget {
  final StatisticsResponse response;
  const CustomerResponseTimesChart({Key? key, required this.response})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: (response.statistics?.length ?? 0) * 70 + 50,
            height: 100,
            child: charts.BarChart(
              [
                charts.Series<Statistics, String>(
                  id: 'read_messages',
                  data: response.statistics!,
                  domainFn: (Statistics current, index) => current.name ?? "",
                  displayName: 'Waktu respons (dalam menit)',
                  measureFn: (Statistics current, index) {
                    List<ResponseTimes> responseTimes = [];
                    current.dailyReport?.forEach((element) {
                      if (element.responseTimes != null) {
                        responseTimes.addAll(element.responseTimes!);
                      }
                    });
                    return responseTimes.isNotEmpty
                        ? responseTimes
                                .map((e) => e.seconds!)
                                .reduce((value, element) => value + element) /
                            responseTimes.length /
                            60
                        : 0;
                  },
                  labelAccessorFn: (Statistics current, _) {
                    List<ResponseTimes> responseTimes = [];
                    current.dailyReport?.forEach((element) {
                      if (element.responseTimes != null) {
                        responseTimes.addAll(element.responseTimes!);
                      }
                    });
                    var avgResponseTime = responseTimes.isNotEmpty
                        ? responseTimes
                                .map((e) => e.seconds!)
                                .reduce((value, element) => value + element) /
                            responseTimes.length
                        : 0;
                    var minutes = (avgResponseTime / 60).round();
                    var seconds = (avgResponseTime % 60).round();

                    return "$minutes";
                  },
                  colorFn: (Statistics current, _) {
                    var materialColor = Colors.lightBlue;
                    return charts.Color(
                        r: materialColor.red,
                        g: materialColor.green,
                        b: materialColor.blue);
                  },
                ),
              ],
              behaviors: [charts.SeriesLegend()],
              barRendererDecorator: charts.BarLabelDecorator<String>(),
            ),
          )
        ],
      ),
    );
  }
}
