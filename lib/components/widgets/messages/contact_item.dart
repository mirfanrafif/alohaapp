import 'package:aloha/components/pages/chat_page.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/response/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/customer_message.dart';

class ContactItem extends StatelessWidget {
  final CustomerMessage customerMessage;

  const ContactItem({Key? key, required this.customerMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessageEntity? lastMessage = customerMessage.message.isNotEmpty
        ? customerMessage.message.first
        : null;
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.black12,
        foregroundImage: AssetImage('assets/image/user.png'),
      ),
      title: Text(customerMessage.customer.name),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: getLastMessage(lastMessage))],
      ),
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
        Provider.of<MessageProvider>(context, listen: false)
            .selectedCustomerId = customerMessage.customer.id;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              contact: customerMessage,
            ),
          ),
        );
      },
    );
  }

  getLastMessage(MessageEntity? lastMessage) {
    if (lastMessage == null) {
      return const Text("");
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (lastMessage.fromMe) buildStatusIcon(lastMessage),
        const SizedBox(width: 8),
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

  Icon buildStatusIcon(MessageEntity message) {
    switch (message.status) {
      case "pending":
        return const Icon(
          Icons.watch_later_outlined,
          size: 12,
        );
      case "sent":
        return const Icon(
          Icons.check,
          size: 12,
          color: Colors.black38,
        );
      case "received":
        return const Icon(
          Icons.check,
          color: Colors.green,
          size: 12,
        );
      case "read":
        return const Icon(
          Icons.check,
          color: Colors.blue,
          size: 12,
        );
      default:
        return const Icon(
          Icons.watch_later_outlined,
          size: 12,
        );
    }
  }
}
