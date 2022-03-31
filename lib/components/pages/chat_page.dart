import 'package:aloha/components/widgets/chat_input.dart';
import 'package:aloha/components/widgets/chat_list.dart';
import 'package:aloha/data/response/Message.dart';
import 'package:aloha/data/service/contact_provider.dart';
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
      body: ChatContent(customer: customer),
    );
  }
}

class ChatContent extends StatefulWidget {
  final Customer customer;
  const ChatContent({Key? key, required this.customer}) : super(key: key);

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  String _currentChat = '';
  var _chatInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatInputController.addListener(() {
      setState(() {
        _currentChat = _chatInputController.text;
      });
    });
    var provider = Provider.of<ContactProvider>(context, listen: false);
    print(widget.customer.id);
    if (provider.getIsFirstLoad(widget.customer.id)) {
      print("first load");
      provider.setFirstLoadDone(widget.customer.id);
      provider.getPastMessages(customerId: widget.customer.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Expanded(
            child: ChatList(
              customer: widget.customer,
            ),
          ),
          ChatInput(chatController: _chatInputController)
        ],
      ),
    );
  }
}
