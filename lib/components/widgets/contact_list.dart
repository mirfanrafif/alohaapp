import 'package:aloha/data/service/message_provider.dart';
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
    Provider.of<ContactProvider>(context, listen: false)
        .getAllContact()
        .then((value) {
      Provider.of<MessageProvider>(context, listen: false)
          .mapContactToCustomerMessage(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(
      builder: (context, value, child) {
        return ListView.builder(
          itemBuilder: (context, index) => ContactItem(
            contact: value.contacts[index],
          ),
          itemCount: value.contacts.length,
        );
      },
    );
  }
}
