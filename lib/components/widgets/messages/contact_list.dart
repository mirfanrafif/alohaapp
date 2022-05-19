import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/message_provider.dart';
import 'contact_item.dart';

class ContactList extends StatefulWidget {
  Function(String) setTitle;
  ContactList({Key? key, required this.setTitle}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _controller = TextEditingController();
  late MessageProvider _provider;
  @override
  void initState() {
    super.initState();
    _provider = Provider.of<MessageProvider>(context, listen: false);
    _provider.init(context);
    _controller.addListener(_onSearchChange);
  }

  void _onSearchChange() {
    debouncing(
      fn: () {
        _provider.searchKeyword = _controller.text;
      },
    );
  }

  Timer? _debounceTimer;

  @override
  void dispose() {
    super.dispose();
    _debounceTimer?.cancel();
    _controller.dispose();
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
        var customerMessage = provider.getCustomerMessage();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: "Cari kontak...",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: customerMessage.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) => ContactItem(
                        customerMessage: customerMessage[index],
                      ),
                      itemCount: customerMessage.length,
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
