import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  TextEditingController chatController;
  ChatInput({Key? key, required this.chatController}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.chatController,
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
              onPressed: () {},
              icon: const Icon(Icons.send),
            ),
            width: 80,
          )
        ],
      ),
    );
  }
}
