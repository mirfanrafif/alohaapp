import 'package:aloha/data/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/response/Contact.dart';

class ChatInput extends StatefulWidget {
  Customer customer;
  ChatInput({Key? key, required this.customer}) : super(key: key);

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
        children: [
          Expanded(
            child: TextField(
              controller: chatController,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.black12),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.black12),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  fillColor: Colors.white),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(
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
            width: 80,
          )
        ],
      ),
    );
  }
}
