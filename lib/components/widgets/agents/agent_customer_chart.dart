// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/sales_provider.dart';
import '../../../data/response/statistics.dart';

class CustomerUnreadMessagesChart extends StatelessWidget {
  final StatisticsResponse response;

  const CustomerUnreadMessagesChart({Key? key, required this.response})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Diagram Jumlah terjawab dan tidak terjawab"),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: double.infinity,
          height: 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                width: (response.statistics!.length * 40) + 50,
                height: 300,
                padding: const EdgeInsets.only(top: 10),
                child: BarChart(
                  BarChartData(
                    barGroups: makeGroups(response),
                    titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (index, meta) {
                                return Text(response
                                        .statistics?[index.toInt()].id
                                        .toString() ??
                                    "");
                              }),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                          ),
                        )),
                    alignment: BarChartAlignment.center,
                    groupsSpace: 20,
                    gridData: FlGridData(
                        show: false,
                        drawVerticalLine: true,
                        verticalInterval: 6),
                    borderData: FlBorderData(show: false),
                    barTouchData: makeTouchData(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  makeGroups(StatisticsResponse response) {
    List<BarChartGroupData> barData = [];

    response.statistics!.asMap().forEach((key, value) {
      barData.add(
        BarChartGroupData(
          barsSpace: 5,
          x: key,
          barRods: [
            BarChartRodData(
              toY: getReadMessagesCount(value),
              color: Colors.lightBlue,
              backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: getReadMessageMaxY(response.statistics!),
                  color: Colors.black12),
            ),
            BarChartRodData(
              toY: value.allUnreadMessageCount!.toDouble(),
              color: Colors.deepOrange,
              backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: getReadMessageMaxY(response.statistics!),
                  color: Colors.black12),
            )
          ],
        ),
      );
    });
    return barData;
  }

  double getReadMessageMaxY(List<Statistics> statistics) {
    double maxY = 0;
    for (var element in statistics) {
      if (element.allUnreadMessageCount!.toDouble() > maxY) {
        maxY = element.allUnreadMessageCount!.toDouble();
      }

      if (getReadMessagesCount(element) > maxY) {
        maxY = getReadMessagesCount(element);
      }
    }
    return maxY;
  }

  double getReadMessagesCount(Statistics current) {
    List<ResponseTimes> responseTimes = [];
    current.dailyReport?.forEach((element) {
      if (element.responseTimes != null) {
        responseTimes.addAll(element.responseTimes!);
      }
    });
    return responseTimes.length.toDouble();
  }

  BarTouchData makeTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
              (response.statistics?[groupIndex].name ?? "") + "\n",
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "Dibaca: " +
                      getReadMessagesCount(response.statistics![groupIndex])
                          .round()
                          .toString() +
                      "\n",
                  style: const TextStyle(color: Colors.lightBlue),
                ),
                TextSpan(
                  text: "Tidak dibaca: " +
                      (response.statistics![groupIndex].allUnreadMessageCount
                              ?.round()
                              .toString() ??
                          ""),
                  style: const TextStyle(color: Colors.deepOrange),
                )
              ]);
        },
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
    return Column(
      children: [
        const Text("Waktu respons terhadap customer"),
        const SizedBox(
          height: 24,
        ),
        SizedBox(
          width: double.infinity,
          height: 300,
          child: BarChart(
            BarChartData(
              barGroups: makeGroups(response),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (index, meta) {
                        return Text(
                            response.statistics?[index.toInt()].id.toString() ??
                                "");
                      }),
                ),
              ),
              gridData: FlGridData(
                  show: true, drawVerticalLine: false, horizontalInterval: 5),
              borderData: FlBorderData(show: false),
              barTouchData: makeTouchData(),
              maxY: 16,
            ),
          ),
        ),
      ],
    );
  }

  makeGroups(StatisticsResponse response) {
    List<BarChartGroupData> barData = [];

    response.statistics!.asMap().forEach((key, value) {
      barData.add(
        BarChartGroupData(
          x: key,
          barRods: [
            BarChartRodData(
                toY: limitY(getResponseTime(value) / 60),
                color: Colors.green,
                backDrawRodData: BackgroundBarChartRodData(
                    show: true, color: Colors.black12, toY: 16)),
          ],
        ),
      );
    });
    return barData;
  }

  double getResponseTime(Statistics current) {
    List<ResponseTimes> responseTimes = [];
    current.dailyReport?.forEach((element) {
      if (element.responseTimes != null) {
        responseTimes.addAll(element.responseTimes!);
      }
    });
    return responseTimes.isNotEmpty
        ? responseTimes
                .map((e) => e.seconds)
                .reduce((value, element) => value! + element!)! /
            responseTimes.length
        : 0;
  }

  BarTouchData makeTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
              (response.statistics?[groupIndex].name ?? "") + "\n",
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (getResponseTime(response.statistics![groupIndex]) / 60)
                          .floor()
                          .toString() +
                      " menit\n" +
                      ((getResponseTime(response.statistics![groupIndex])) % 60)
                          .round()
                          .toString() +
                      " detik",
                  style: const TextStyle(color: Colors.greenAccent),
                ),
              ]);
        },
      ),
    );
  }
}

double limitY(double value) {
  return value > 16 ? 16 : value;
}

class DailyResponseTimeCustomerChart extends StatelessWidget {
  const DailyResponseTimeCustomerChart({Key? key}) : super(key: key);

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
          height: 300,
          child: BarChart(
            BarChartData(
              barGroups: makeGroups(provider.statistics!),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (index, meta) => Text(
                        provider.statistics!.dailyReport?[index.round()].date ??
                            ""),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 5),
                ),
              ),
              gridData: FlGridData(
                  show: true, drawVerticalLine: false, horizontalInterval: 5),
              maxY: 16,
              borderData: FlBorderData(show: false),
              barTouchData: makeTouchData(provider.statistics!),
            ),
          ),
        ),
      ],
    );
  }

  makeGroups(Statistics statistics) {
    List<BarChartGroupData> barData = [];

    statistics.dailyReport!.asMap().forEach((index, element) {
      barData.add(BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: limitY((element.average ?? 0) / 60),
            backDrawRodData: BackgroundBarChartRodData(
              toY: 16,
              show: true,
              color: Colors.black12,
            ),
          ),
        ],
      ));
    });
    return barData;
  }

  BarTouchData makeTouchData(Statistics statistics) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            ((statistics.dailyReport?[groupIndex].average ?? 0) / 60)
                    .floor()
                    .toString() +
                " menit\n" +
                ((statistics.dailyReport?[groupIndex].average ?? 0) % 60)
                    .round()
                    .toString() +
                " detik",
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          );
        },
      ),
    );
  }
}

class ResponseTimePerQuestionChart extends StatelessWidget {
  const ResponseTimePerQuestionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        height: 300,
        child: BarChart(
          BarChartData(
            barGroups: makeGroups(provider.dailyReport!.responseTimes!),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 5),
              ),
            ),
            gridData: FlGridData(
                show: true, drawVerticalLine: false, horizontalInterval: 5),
            borderData: FlBorderData(show: false),
            maxY: 16,
            barTouchData: makeTouchData(provider.dailyReport!.responseTimes!),
          ),
        ),
      ),
    );
  }

  BarTouchData makeTouchData(List<ResponseTimes> responseTimes) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            // responseTimes.length > 20
            //     ? (responseTimes[groupIndex].question ?? "").substring(0, 20)
            //     : (responseTimes[groupIndex].question ?? "") + "\n",
            (responseTimes[groupIndex].question ?? "") + "\n",
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ((responseTimes[groupIndex].seconds ?? 0) / 60)
                        .floor()
                        .toString() +
                    " menit\n" +
                    ((responseTimes[groupIndex].seconds ?? 0) % 60)
                        .round()
                        .toString() +
                    " detik\n",
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  makeGroups(List<ResponseTimes> responseTimes) {
    List<BarChartGroupData> barData = [];

    responseTimes.asMap().forEach((key, value) {
      barData.add(
        BarChartGroupData(
          x: key,
          barRods: [
            BarChartRodData(
              toY: limitY((value.seconds ?? 0) / 60),
              color: (value.seconds ?? 0) / 60 > 10
                  ? Colors.redAccent
                  : Colors.greenAccent,
              backDrawRodData: BackgroundBarChartRodData(
                color: Colors.black12,
                show: true,
                toY: 16,
              ),
            ),
          ],
        ),
      );
    });
    return barData;
  }
}
