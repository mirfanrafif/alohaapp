import 'package:aloha/components/widgets/contact_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Aloha'),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text("Irfan Rafif"),
                accountEmail: Text("mirfanrafif17@gmail.com"),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text("Profil"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: const ContactList());
  }
}
