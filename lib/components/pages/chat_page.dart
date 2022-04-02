import 'package:aloha/components/widgets/chat_input.dart';
import 'package:aloha/components/widgets/chat_list.dart';
import 'package:flutter/material.dart';

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
                  //TODO: show customer bottom sheet
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

class CustomerDetails extends StatelessWidget {
  final Customer customer;

  const CustomerDetails({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: <Widget>[
          const CircleAvatar(
            backgroundColor: Colors.black12,
            foregroundImage: AssetImage('assets/image/user.png'),
            radius: 40,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            customer.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(customer.phoneNumber),
        ],
      ),
    );
  }
}

const showCustomer = "show_customer";
