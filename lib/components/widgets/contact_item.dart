import 'package:aloha/components/pages/chat_page.dart';
import 'package:aloha/data/response/Contact.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:flutter/material.dart';

import '../../data/models/customer_message.dart';

class ContactItem extends StatelessWidget {
  final CustomerMessage customerMessage;

  const ContactItem({Key? key, required this.customerMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.black12,
          foregroundImage: AssetImage('assets/image/user.png'),
        ),
        title: Text(customerMessage.customer.name),
        subtitle: Text(
          customerMessage.message.isNotEmpty
              ? customerMessage.message.first.message
              : "",
          maxLines: 2,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              customer: customerMessage.customer,
            ),
          ),
        );
      },
    );
  }
}
