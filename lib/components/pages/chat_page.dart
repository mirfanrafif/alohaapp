import 'package:aloha/components/widgets/chat_input.dart';
import 'package:aloha/components/widgets/chat_list.dart';
import 'package:flutter/material.dart';

import '../../data/response/Contact.dart';
import '../widgets/customer_details.dart';

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
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text("Show customer details"),
                value: showCustomer,
              ),
            ],
            onSelected: (result) {
              if (result != null) {
                if (result == showCustomer) {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return CustomerDetails(
                          customer: customer,
                        );
                      });
                }
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              customer: customer,
            ),
          ),
          ChatInput(
            customer: customer,
          )
        ],
      ),
    );
  }
}

const showCustomer = "show_customer";
