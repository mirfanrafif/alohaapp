import 'package:aloha/components/widgets/customer_daily_chart.dart';
import 'package:aloha/data/providers/sales_provider.dart';
import 'package:aloha/data/response/statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'agent_customer_chart.dart';

class AgentStatistics extends StatelessWidget {
  const AgentStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          Expanded(child: AgentStatisticsContent()),
        ],
      ),
    );
  }
}

class AgentStatisticsContent extends StatefulWidget {
  const AgentStatisticsContent({Key? key}) : super(key: key);

  @override
  State<AgentStatisticsContent> createState() => _AgentStatisticsContentState();
}

class _AgentStatisticsContentState extends State<AgentStatisticsContent> {
  late SalesProvider _provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provider = Provider.of<SalesProvider>(context, listen: false);
  }

  void selectDate() async {
    var datetimeRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020, 1, 1),
        lastDate: DateTime.now());
    _provider.selectedDate = datetimeRange;
    _provider.getStatistics().then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value.message)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(builder: (context, provider, child) {
      return ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  provider.selectedDate != null
                      ? provider.getFormattedStartDate() +
                          " s.d " +
                          provider.getFormattedEndDate()
                      : "Pilih tanggal",
                ),
              ),
              IconButton(
                onPressed: selectDate,
                icon: const Icon(
                  Icons.date_range,
                  color: Colors.deepOrange,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          if (provider.statisticsResponse != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Statistik untuk"),
                    Text(
                      provider.statisticsResponse?.fullName ?? "",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text("Laporan per-customer dari sales " +
                (provider.selectedAgent?.fullName ?? "")),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pilih Customer"),
                    DropdownButton<int>(
                        value: provider.selectedCustomerId,
                        isExpanded: true,
                        items: provider.statisticsResponse!.statistics
                                ?.map((e) => DropdownMenuItem<int>(
                                      child: Text((e.name ?? "")),
                                      value: e.id,
                                    ))
                                .toList() ??
                            [],
                        onChanged: (newValue) {
                          if (newValue != null) {
                            provider.changeSelectedCustomer(newValue);
                          }
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (provider.statistics != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Pesan tidak terjawab",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            provider.statistics?.allUnreadMessageCount
                                    ?.toString() ??
                                "",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Rata-rata waktu respons",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            (provider.statistics?.averageAllResponseTime
                                        ?.floor()
                                        .toString() ??
                                    "") +
                                "\ndetik",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Jumlah pesan dijawab",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            provider.statistics?.dailyReport?.length
                                    .toString() ??
                                "",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const AgentStatisticsCustomerChart(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text("Laporan per-tanggal dari customer " +
                (provider.statistics?.name ?? "")),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text("Pilih tanggal"),
                    DropdownButton<String>(
                        value: provider.selectedReport,
                        isExpanded: true,
                        items: provider.statistics!.dailyReport!.isNotEmpty
                            ? provider.statistics!.dailyReport
                                ?.map((e) => DropdownMenuItem(
                                      child: Text(e.date ?? ""),
                                      value: e.date,
                                    ))
                                .toList()
                            : [],
                        onChanged: (newValue) {
                          provider.selectedReport = newValue;
                        })
                  ],
                ),
              ),
            )
          ],
          if (provider.dailyReport != null) ...[
            Card(
              child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Waktu respon pada tanggal " +
                          (provider.dailyReport!.date ?? "")),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  "Pesan tidak terjawab",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  provider.dailyReport?.unreadMessage
                                          ?.toString() ??
                                      "",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  "Rata-rata waktu respons",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  (provider.dailyReport?.average
                                              ?.floor()
                                              .toString() ??
                                          "") +
                                      "\ndetik",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  "Pesan telat menjawab",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  provider.dailyReport?.lateResponse
                                          ?.toString() ??
                                      "",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const AgentCustomerDailyChart()
                    ],
                  )),
            )
          ],
        ],
      );
    });
  }
}
