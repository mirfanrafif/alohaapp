import 'dart:async';

import 'package:aloha/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/message_provider.dart';
import 'contact_item.dart';

class ContactList extends StatefulWidget {
  final Function(String) setTitle;
  const ContactList({Key? key, required this.setTitle}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late MessageProvider _provider;
  @override
  void initState() {
    super.initState();
    _provider = Provider.of<MessageProvider>(context, listen: false);
    _provider.init(context);
  }

  Timer? _debounceTimer;

  @override
  void dispose() {
    super.dispose();
    _debounceTimer?.cancel();
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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (newValue) {
                  debouncing(fn: () {
                    provider.searchKeyword = newValue;
                  });
                },
                decoration: alohaInputDecoration("Cari Kontak..."),
              ),
            ),
            Expanded(
              child: provider.customerMessage.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) => ContactItem(
                        customerMessage: provider.customerMessage[index],
                      ),
                      itemCount: provider.customerMessage.length,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        );
      },
    );
  }
}
