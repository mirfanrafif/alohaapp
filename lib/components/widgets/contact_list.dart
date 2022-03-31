import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/service/contact_provider.dart';
import 'contact_item.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemBuilder: (context, index) => ContactItem(
            customerMessage: provider.customerMessage[index],
          ),
          itemCount: provider.customerMessage.length,
        );
      },
    );
  }
}
