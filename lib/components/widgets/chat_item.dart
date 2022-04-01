import 'package:aloha/data/response/Message.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final Message message;
  const ChatItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: message.fromMe ? 30 : 8,
        right: message.fromMe ? 8 : 30,
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
                borderRadius: BorderRadius.all(Radius.circular(16))),
            margin: EdgeInsets.zero,
            color: message.fromMe ? Colors.lightGreen : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: message.fromMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (message.type == "image") buildImageView(),
                  Text(
                    message.message,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
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

  Widget buildImageView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        child: Image(
          image: NetworkImage(message.fromMe
              ? "https://dev.mirfanrafif.me/message/image/${message.file}"
              : "https://solo.wablas.com/image/${message.file}"),
          width: 300,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
