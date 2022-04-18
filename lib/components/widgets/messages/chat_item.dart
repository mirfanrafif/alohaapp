import 'package:aloha/data/response/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chat_image.dart';

double chatMargin = 80;

class ChatItem extends StatelessWidget {
  final Message message;
  const ChatItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: message.fromMe ? chatMargin : 8,
        right: message.fromMe ? 8 : chatMargin,
        top: 8,
        bottom: 8,
      ),
      alignment: message.fromMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment:
            message.fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            margin: EdgeInsets.zero,
            color: message.fromMe
                ? const Color.fromARGB(255, 202, 255, 191)
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: message.fromMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (message.type == "image") ChatImage(message: message),
                  if (message.type == "document") buildDocumentView(),
                  if (message.message.isNotEmpty)
                    Text(
                      message.message,
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.createdAt != null
                            ? DateFormat("Hm").format(message.createdAt!)
                            : "",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (message.fromMe) buildStatusIcon(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            message.senderName,
            style: const TextStyle(color: Colors.black38),
          )
        ],
      ),
    );
  }

  Icon buildStatusIcon() {
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

  Widget buildDocumentView() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(35, 0, 0, 0)),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message.file ?? "",
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.download,
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}
