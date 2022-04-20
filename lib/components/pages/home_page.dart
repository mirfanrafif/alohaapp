import 'package:aloha/components/pages/broadcast_page.dart';
import 'package:aloha/components/pages/job_details_page.dart';
import 'package:aloha/components/pages/job_page.dart';
import 'package:aloha/components/pages/login_page.dart';
import 'package:aloha/components/pages/profile_page.dart';
import 'package:aloha/components/pages/start_message_page.dart';
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

const String _pesanLabel = "Pesan";
const String _salesLabel = "Sales";
const String _jobLabel = "Job";
const String _profilLabel = "Profil";
const String _openBroadcastPage = "openBroadcast";

class _HomePageState extends State<HomePage> {
  String _selectedIndex = _pesanLabel;
  String _title = _pesanLabel;
  late UserProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          title: Text(_title),
          actions: getAppBarActions(),
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
                title: const Text(_pesanLabel),
                onTap: () {
                  setState(() {
                    _selectedIndex = _pesanLabel;
                    _title = _pesanLabel;
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              if (provider.user.role == "admin") ...getAdminMenus(),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text(_profilLabel),
                onTap: () {
                  setState(() {
                    _selectedIndex = _profilLabel;
                    _title = _profilLabel;
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
        floatingActionButton: getFab(),
      ),
    );
  }

  FloatingActionButton? getFab() {
    switch (_selectedIndex) {
      case _pesanLabel:
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StartMessagePage()));
          },
          child: const Icon(Icons.message),
        );
      case _jobLabel:
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => JobDetailsPage(),
            ));
          },
          child: Icon(Icons.add),
        );
      default:
        return null;
    }
  }

  List<Widget>? getAppBarActions() {
    switch (_selectedIndex) {
      case _pesanLabel:
        return [
          if (_provider.user.role == "admin")
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  child: Text("Broadcast Message"),
                  value: _openBroadcastPage,
                ),
              ],
              onSelected: (result) {
                if (result != null) {
                  switch (result) {
                    case _openBroadcastPage:
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BroadcastPage(),
                      ));
                      break;
                    default:
                      break;
                  }
                }
              },
            )
        ];
      default:
        return null;
    }
  }

  List<Widget> getAdminMenus() {
    return [
      ListTile(
        leading: const Icon(Icons.people),
        title: const Text(_salesLabel),
        onTap: () {
          setState(() {
            _selectedIndex = _salesLabel;
            _title = _salesLabel;
          });
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: const Icon(Icons.work),
        title: const Text(_jobLabel),
        onTap: () {
          setState(() {
            _selectedIndex = _jobLabel;
            _title = _jobLabel;
          });
          Navigator.pop(context);
        },
      ),
      const Divider(),
    ];
  }

  Widget getBody() {
    switch (_selectedIndex) {
      case _pesanLabel:
        return const ContactList();
      case _salesLabel:
        return const SalesList();
      case _jobLabel:
        return const JobPage();
      case _profilLabel:
        return const ProfilePage();
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
          "https://" + baseUrl + "/user/profile_image/" + profilePhoto;
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
