import 'package:aloha/components/widgets/chat_item.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/response/contact.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key, required this.customer}) : super(key: key);
  final Customer customer;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  var chatListController = ScrollController();
  late MessageProvider messageProvider;

  @override
  void initState() {
    super.initState();
    chatListController.addListener(_loadMore);
    messageProvider = Provider.of<MessageProvider>(context, listen: false);
    if (messageProvider.getIsFirstLoad(widget.customer.id)) {
      messageProvider.setFirstLoadDone(widget.customer.id);
      messageProvider.getPastMessages(customerId: widget.customer.id);
    }
  }

  void _loadMore() {
    if (chatListController.position.pixels ==
        chatListController.position.maxScrollExtent) {
      if (messageProvider.getIsAllLoaded(widget.customer.id)) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sudah di pesan paling atas")));
        return;
      }
      messageProvider.getPastMessages(
        customerId: widget.customer.id,
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
        var messages = provider.getMessageByCustomerId(widget.customer.id);
        if (messages.isNotEmpty) {
          return Column(
            children: [
              if (provider.chatLoading) const LinearProgressIndicator(),
              Expanded(
                child: ListView.builder(
                  controller: chatListController,
                  itemBuilder: (context, index) {
                    return ChatItem(message: messages[index]);
                  },
                  reverse: true,
                  itemCount: messages.length,
                ),
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
