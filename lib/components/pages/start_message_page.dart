import 'dart:async';

import 'package:aloha/components/pages/chat_page.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/response/contact.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartMessagePage extends StatefulWidget {
  const StartMessagePage({Key? key}) : super(key: key);

  @override
  State<StartMessagePage> createState() => _StartMessagePageState();
}

class _StartMessagePageState extends State<StartMessagePage> {
  String keyword = "";
  late MessageProvider _provider;

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<MessageProvider>(context, listen: false);
  }

  void debouncing({required Function() fn, int waitForMs = 500}) {
    // if this function is called before 500ms [waitForMs] expired
    //cancel the previous call
    _debounceTimer?.cancel();
    // set a 500ms [waitForMs] timer for the [fn] to be called
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Cari customer")),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      debouncing(fn: () {
                        keyword = value;
                      });
                    });
                  },
                  decoration: alohaInputDecoration("Cari Kontak..."),
                ),
              ),
              if (keyword.isNotEmpty)
                Expanded(
                  child: FutureBuilder<ApiResponse<List<Customer>?>>(
                    builder: (context, snapshot) {
                      var response = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (response != null &&
                            response.success &&
                            response.data != null) {
                          var customers = response.data!;
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(customers[index].name),
                                subtitle: Text(customers[index].phoneNumber),
                                onTap: () {
                                  startConversation(customers[index].id);
                                },
                              );
                            },
                            itemCount: customers.length,
                          );
                        }
                        return Container();
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    future: provider.searchNewCustomer(keyword),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  void startConversation(int customerId) async {
    var response = await _provider.startConversation(customerId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating, content: Text(response.message)));
    if (response.success) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ChatPage(contact: response.data!),
      ));
    }
  }
}
