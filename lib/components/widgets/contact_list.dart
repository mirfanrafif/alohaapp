import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/service/contact_service.dart';
import 'contact_item.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ContactService>(
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
