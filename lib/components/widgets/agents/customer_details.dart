import 'package:aloha/components/pages/delegate_customer_page.dart';
import 'package:aloha/components/widgets/button.dart';
import 'package:aloha/data/models/customer_message.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({Key? key}) : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  late CustomerMessage contact;

  @override
  void initState() {
    super.initState();
    contact = Provider.of<MessageProvider>(context, listen: false)
        .getSelectedCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
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
            contact.customer.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(contact.customer.phoneNumber),
          const SizedBox(
            height: 32,
          ),
          const Text("Sales yang melayani:"),
          const SizedBox(
            height: 8,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(
                bottom: 16,
                left: 16,
                right: 16,
              ),
              decoration: const BoxDecoration(
                borderRadius: alohaRadius,
                color: Colors.white,
              ),
              child: Text(contact.agents[index].fullName),
            ),
            itemCount: contact.agents.length,
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: alohaButton("Delegasikan Sales", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DelegateCustomerPage(),
                  ));
            }),
          )
        ],
      ),
    );
  }
}
