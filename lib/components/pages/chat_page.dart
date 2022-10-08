import 'package:aloha/components/widgets/messages/chat_input.dart';
import 'package:aloha/components/widgets/messages/chat_list.dart';
import 'package:aloha/data/models/customer_message.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/providers/user_provider.dart';
import 'package:aloha/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/agents/customer_details.dart';

class ChatPage extends StatelessWidget {
  final CustomerMessage contact;

  const ChatPage({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Consumer<MessageProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.getSelectedCustomer().customer.name,
              ),
              Text(
                provider.getSelectedCustomer().customer.phoneNumber,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            if (userProvider.user.role == "admin")
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text("Show customer details"),
                    value: showCustomer,
                  ),
                ],
                shape: const RoundedRectangleBorder(borderRadius: alohaRadius),
                onSelected: (result) {
                  if (result != null) {
                    if (result == showCustomer) {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return const CustomerDetails();
                        },
                      );
                    }
                  }
                },
              )
          ],
        ),
        body: Column(
          children: const [
            Expanded(
              child: ChatList(),
            ),
            ChatInput()
          ],
        ),
      );
    });
  }
}

const showCustomer = "show_customer";
