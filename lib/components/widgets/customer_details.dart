import 'package:flutter/material.dart';

import '../../data/response/Contact.dart';

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
          const SizedBox(
            height: 32,
          ),
          OutlinedButton(onPressed: () {}, child: Text("Tombol untuk apa gitu"))
        ],
      ),
    );
  }
}
