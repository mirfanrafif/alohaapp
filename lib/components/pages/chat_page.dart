import 'package:aloha/components/widgets/chat_input.dart';
import 'package:aloha/components/widgets/chat_list.dart';
import 'package:aloha/data/response/Message.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/response/Contact.dart';

class ChatPage extends StatelessWidget {
  final Customer customer;

  const ChatPage({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customer.name),
            Text(
              customer.phoneNumber,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              customer: customer,
            ),
          ),
          ChatInput(
            customer: customer,
          )
        ],
      ),
    );
  }
}
