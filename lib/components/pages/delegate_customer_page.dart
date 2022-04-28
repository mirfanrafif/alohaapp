import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/providers/sales_provider.dart';
import 'package:aloha/data/response/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DelegateCustomerPage extends StatefulWidget {
  const DelegateCustomerPage({Key? key}) : super(key: key);

  @override
  State<DelegateCustomerPage> createState() => _DelegateCustomerPageState();
}

class _DelegateCustomerPageState extends State<DelegateCustomerPage> {
  List<User> salesList = [];

  @override
  void initState() {
    super.initState();
    var salesProvider = Provider.of<SalesProvider>(context, listen: false);
    salesProvider.getAllAgents().then((salesListResponse) {
      if (salesListResponse.success && salesListResponse.data != null) {
        setState(() {
          salesList = salesListResponse.data!;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(salesListResponse.message)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Delegasi Customer"),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(salesList[index].fullName),
                subtitle: Text(
                    salesList[index].job?.map((e) => e.job.name).join(', ') ??
                        ""),
                trailing: getAsssignButton(
                  idFromList: salesList[index].id,
                  currentlyHandling: provider.getSelectedCustomer().agents,
                  delegateCallback: () {
                    provider.assignCustomerToSales(
                        salesList[index].id, context);
                  },
                  undelegateCallback: () {
                    provider.unassignCustomerToSales(
                        salesList[index].id, context);
                  },
                ),
              ),
            ),
            itemCount: salesList.length,
          ),
        );
      },
    );
  }

  Widget? getAsssignButton(
      {required int idFromList,
      required List<User> currentlyHandling,
      required Function() delegateCallback,
      required Function() undelegateCallback}) {
    var salesIndex =
        currentlyHandling.indexWhere((element) => element.id == idFromList);

    if (salesIndex == -1) {
      return IconButton(
        onPressed: delegateCallback,
        icon: const Icon(Icons.add),
      );
    } else {
      return IconButton(
        onPressed: undelegateCallback,
        icon: const Icon(Icons.remove),
      );
    }
  }
}
