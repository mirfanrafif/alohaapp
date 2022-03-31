import 'package:aloha/components/pages/chat_page.dart';
import 'package:aloha/data/response/Contact.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;

  const ContactItem({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.black12,
          foregroundImage: AssetImage('assets/image/user.png'),
        ),
        title: Text(contact.customer.name),
        subtitle: Text(contact.lastMessage.message),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              contact: contact,
            ),
          ),
        );
      },
    );
  }

  Widget buildContactItemText() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact.customer.name,
            style: const TextStyle(color: Colors.black87, fontSize: 18),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            contact.lastMessage.message.characters.take(40).string,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}

class ContactItemData {
  int id = 0;
  String nama = "";
  String lastMessage = "";

  ContactItemData(
      {required this.id, required this.nama, required this.lastMessage});

  factory ContactItemData.fromContact(Contact contact) {
    return ContactItemData(
        id: contact.customer.id,
        nama: contact.customer.name,
        lastMessage: contact.lastMessage.message);
  }
}
