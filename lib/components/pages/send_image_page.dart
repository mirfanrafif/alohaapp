import 'dart:io';

import 'package:aloha/data/response/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/providers/message_provider.dart';

class SendImagePage extends StatefulWidget {
  final XFile file;
  final Customer customer;
  final String message;
  const SendImagePage({
    Key? key,
    required this.file,
    required this.customer,
    required this.message,
  }) : super(key: key);

  @override
  State<SendImagePage> createState() => _SendImagePageState();
}

class _SendImagePageState extends State<SendImagePage> {
  var chatController = TextEditingController();
  var _currentChat = '';
  late MessageProvider provider;

  @override
  void initState() {
    super.initState();
    _currentChat = widget.message;
    chatController.addListener(() {
      setState(() {
        _currentChat = chatController.text;
      });
    });
    provider = Provider.of<MessageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.customer.name),
            Text(
              widget.customer.phoneNumber,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: Image(
                image: FileImage(
                  File(widget.file.path),
                ),
              ),
            ),
            Container(
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
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          hintStyle: const TextStyle(color: Colors.white70),
                          fillColor: Colors.white),
                      minLines: 1,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
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
                      color: Colors.green,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    provider
        .sendImage(
            file: widget.file,
            customerNumber: widget.customer.phoneNumber,
            message: _currentChat)
        .then((_) {
      Navigator.pop(context);
    });
  }

  InputBorder inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Colors.white),
    borderRadius: BorderRadius.all(
      Radius.circular(16),
    ),
  );
}
