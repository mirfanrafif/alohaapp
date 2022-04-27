import 'package:aloha/components/widgets/messages/chat_item.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/response/contact.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  var chatListController = ScrollController();
  late MessageProvider messageProvider;
  late Customer customer;

  @override
  void initState() {
    super.initState();
    chatListController.addListener(_loadMore);
    messageProvider = Provider.of<MessageProvider>(context, listen: false);
    customer = messageProvider.getSelectedCustomer().customer;
    if (messageProvider.getIsFirstLoad()) {
      messageProvider.setFirstLoadDone();
      messageProvider.getPastMessages();
    }
  }

  void _loadMore() {
    if (chatListController.position.pixels ==
        chatListController.position.maxScrollExtent) {
      if (messageProvider.getIsAllLoaded(customer.id)) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sudah di pesan paling atas")));
        return;
      }
      messageProvider.getPastMessages(
        loadMore: true,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    chatListController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        var messages = provider.getMessageByCustomerId(customer.id);
        if (messages.isNotEmpty) {
          return Column(
            children: [
              if (provider.chatLoading) const LinearProgressIndicator(),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) =>
                        ChatItem(message: messages[index]),
                    separatorBuilder: (context, index) {
                      var next = messages[index + 1];
                      var current = messages[index];

                      var currentDate = DateTime(current.createdAt!.year,
                          current.createdAt!.month, current.createdAt!.day);
                      var nextDate = DateTime(next.createdAt!.year,
                          next.createdAt!.month, next.createdAt!.day);
                      //compare date
                      if (currentDate.compareTo(nextDate) == 1) {
                        return Chip(
                            label: Text(
                                '${current.createdAt!.day}/${current.createdAt!.month}/${current.createdAt!.year}'));
                      } else {
                        return const SizedBox(
                          width: 0,
                        );
                      }
                    },
                    itemCount: messages.length,
                    reverse: true,
                    controller: chatListController),
              ),
            ],
          );
        } else {
          return const EmptyChat();
        }
      },
    );
  }

  void scrollToBottom() {
    chatListController.jumpTo(0);
  }
}

class EmptyChat extends StatelessWidget {
  const EmptyChat({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            image: AssetImage('assets\\image\\empty_message_bg.png'),
            height: 200,
          ),
          Text(
            "Chat Kosong",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text("Pesan akan tampil disini")
        ],
      ),
    );
  }
}
