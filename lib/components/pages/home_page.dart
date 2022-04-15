import 'package:aloha/components/pages/job_page.dart';
import 'package:aloha/components/pages/login_page.dart';
import 'package:aloha/components/widgets/messages/contact_list.dart';
import 'package:aloha/components/widgets/agents/sales_list.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/providers/user_provider.dart';
import 'package:aloha/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

const String pesanLabel = "Pesan";
const String salesLabel = "Sales";
const String jobLabel = "Job";
const String profilLabel = "Profil";

class _HomePageState extends State<HomePage> {
  String _selectedIndex = pesanLabel;
  String _title = pesanLabel;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          title: Text(_title),
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
                leading: const Icon(Icons.message),
                title: const Text(pesanLabel),
                onTap: () {
                  setState(() {
                    _selectedIndex = pesanLabel;
                    _title = pesanLabel;
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              if (provider.user.role == "admin") ...getAdminMenus(),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text(profilLabel),
                onTap: () {
                  setState(() {
                    _selectedIndex = profilLabel;
                    _title = profilLabel;
                  });
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
            ],
          ),
        ),
        body: getBody(),
      ),
    );
  }

  List<Widget> getAdminMenus() {
    return [
      ListTile(
        leading: const Icon(Icons.people),
        title: const Text(salesLabel),
        onTap: () {
          setState(() {
            _selectedIndex = salesLabel;
            _title = salesLabel;
          });
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: const Icon(Icons.work),
        title: const Text(jobLabel),
        onTap: () {
          setState(() {
            _selectedIndex = jobLabel;
            _title = jobLabel;
          });
          Navigator.pop(context);
        },
      ),
      const Divider(),
    ];
  }

  Widget getBody() {
    switch (_selectedIndex) {
      case pesanLabel:
        return const ContactList();
      case salesLabel:
        return const SalesList();
      case jobLabel:
        return const JobPage();
      default:
        return Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets\\image\\under_contruction.png",
                  width: 200,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Masih dalam tahap pengembangan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text("Mohon bersabar")
              ],
            ),
          ),
        );
    }
  }

  Widget renderProfilePicture(String? profilePhoto) {
    if (profilePhoto != null && profilePhoto.isNotEmpty) {
      var imageUrl =
          "https://" + BASE_URL + "/user/profile_image/" + profilePhoto;
      return ClipOval(
        child: Image(
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
}
