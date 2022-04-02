import 'package:aloha/data/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/response/Contact.dart';

class ChatInput extends StatefulWidget {
  final Customer customer;

  const ChatInput({Key? key, required this.customer}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  var chatController = TextEditingController();
  var _currentChat = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController.addListener(() {
      setState(() {
        _currentChat = chatController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: chatController,
              decoration: InputDecoration(
                  hintText: "Tulis pesan disini...",
                  contentPadding: const EdgeInsets.all(8),
                  prefixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.attachment)),
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  fillColor: Colors.white),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(32),
                ),
                color: Colors.amber),
            child: IconButton(
              onPressed: () {
                Provider.of<MessageProvider>(context, listen: false)
                    .sendMessage(
                        customerNumber: widget.customer.phoneNumber,
                        message: _currentChat);
                chatController.clear();
              },
              icon: const Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }

  InputBorder inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Colors.black12),
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  );
}
