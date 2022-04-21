import 'package:aloha/data/response/message.dart';
import 'package:flutter/material.dart';

class ChatDocument extends StatelessWidget {
  final Message message;
  const ChatDocument({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              message.file!.split('/').last,
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
