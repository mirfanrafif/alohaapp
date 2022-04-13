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
        height: 200,
        child: BarChart([
          Series<ResponseTimes, String>(
              id: 'Agent Customer Daily Report',
              data: provider.dailyReport!.responseTimes!,
              colorFn: (ResponseTimes times, _) => times.seconds! > 600
                  ? Color.fromHex(code: "#ff6361")
                  : Color.fromHex(code: "#003f5c"),
              measureLowerBoundFn: (_, __) => 0,
              domainFn: (ResponseTimes times, index) => index?.toString() ?? "",
              measureFn: (ResponseTimes times, index) =>
                  (times.seconds ?? 0) / 60),
        ]),
      ),
    );
  }
}
