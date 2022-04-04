import 'package:aloha/components/pages/login_page.dart';
import 'package:aloha/components/widgets/contact_list.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/providers/user_provider.dart';
import 'package:aloha/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Aloha'),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(provider.user.fullName),
                accountEmail: Text(provider.user.email),
                currentAccountPicture:
                    renderProfilePicture(provider.user.profilePhoto),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text("Profil"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  Provider.of<MessageProvider>(context, listen: false).logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                },
              ),
            ],
          ),
        ),
        body: ContactList(),
      ),
    );
  }

  Widget renderProfilePicture(String? profilePhoto) {
    if (profilePhoto != null && profilePhoto.isNotEmpty) {
      var imageUrl =
          "https://" + BASE_URL + "/user/profile_image/" + profilePhoto;
      return CircleAvatar(
        foregroundImage: NetworkImage(imageUrl),
      );
    } else {
      return const CircleAvatar(
        foregroundImage: AssetImage('assets/image/user.png'),
        backgroundColor: Colors.black12,
      );
    }
  }
}
