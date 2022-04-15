import 'package:aloha/components/pages/chat_page.dart';
import 'package:aloha/data/response/Message.dart';
import 'package:flutter/material.dart';

import '../../../data/models/customer_message.dart';

class ContactItem extends StatelessWidget {
  final CustomerMessage customerMessage;

  const ContactItem({Key? key, required this.customerMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Message? lastMessage = customerMessage.message.isNotEmpty
        ? customerMessage.message.first
        : null;
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.black12,
        foregroundImage: AssetImage('assets/image/user.png'),
      ),
      title: Text(customerMessage.customer.name),
      subtitle: getLastMessage(lastMessage),
      trailing: customerMessage.unread > 0
          ? ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 24,
                height: 24,
                color: Colors.deepOrange,
                child: Center(
                  child: Text(
                    customerMessage.unread > 9
                        ? "9+"
                        : customerMessage.unread.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          : null,
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

  getLastMessage(Message? lastMessage) {
    if (lastMessage == null) {
      return const Text("");
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (lastMessage.type != "text") ...[
          const Icon(
            Icons.attachment,
            color: Colors.black45,
          ),
          const SizedBox(width: 8)
        ],
        Expanded(
            child: lastMessage.message.isNotEmpty
                ? Text(
                    lastMessage.message,
                    maxLines: 2,
                  )
                : Text(lastMessage.type)),
      ],
    );
  }
}
