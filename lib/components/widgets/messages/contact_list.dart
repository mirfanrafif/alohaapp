import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/message_provider.dart';
import 'contact_item.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<MessageProvider>(context, listen: false);
    if (!provider.initDone) {
      provider.init();
    }
    _searchController.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     controller: _searchController,
            //     decoration: const InputDecoration(
            //       labelText: "Cari kontak...",
            //       border: OutlineInputBorder(),
            //       contentPadding: EdgeInsets.all(8),
            //       suffixIcon: Icon(Icons.search),
            //     ),
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => ContactItem(
                  customerMessage: provider.customerMessage[index],
                ),
                itemCount: provider.customerMessage.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
