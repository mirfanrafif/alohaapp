import 'package:aloha/data/providers/app_provider.dart';
import 'package:aloha/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aloha/utils/constants.dart';

import '../../data/providers/message_provider.dart';
import '../pages/login_page.dart';

class AlohaDrawer extends StatelessWidget {
  final Function(String newSelectedIndex, String newTitle) updateSelectedPage;
  const AlohaDrawer({Key? key, required this.updateSelectedPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) => Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(provider.user.fullName),
              accountEmail: Text(provider.user.email),
              currentAccountPicture:
                  renderProfilePicture(provider.user.profilePhoto),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text(pesanLabel),
              onTap: () {
                updateSelectedPage(pesanLabel, pesanLabel);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            if (provider.user.role == "admin") ...getAdminMenus(context),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text(profilLabel),
              onTap: () {
                updateSelectedPage(profilLabel, profilLabel);
                Navigator.pop(context);
              },
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
            Expanded(child: Container()),
            getAppVersionLabel()
          ],
        ),
      ),
    );
  }

  List<Widget> getAdminMenus(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.people),
        title: const Text(salesLabel),
        onTap: () {
          updateSelectedPage(salesLabel, salesLabel);
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: const Icon(Icons.work),
        title: const Text(jobLabel),
        onTap: () {
          updateSelectedPage(jobLabel, jobLabel);
          Navigator.pop(context);
        },
      ),
      const Divider(),
    ];
  }

  Widget renderProfilePicture(String? profilePhoto) {
    if (profilePhoto != null && profilePhoto.isNotEmpty) {
      var imageUrl =
          "https://" + baseUrl + "/user/profile_image/" + profilePhoto;
      return ClipOval(
        child: Image(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl),
            errorBuilder: (context, object, e) {
              return const CircleAvatar(
                foregroundImage: AssetImage('assets/image/user.png'),
                backgroundColor: Colors.black12,
              );
            }),
      );
    } else {
      return const CircleAvatar(
        foregroundImage: AssetImage('assets/image/user.png'),
        backgroundColor: Colors.black12,
      );
    }
  }

  Widget getAppVersionLabel() {
    return Consumer<AppProvider>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text("App Version: " + value.appVersion),
      ),
    );
  }
}
