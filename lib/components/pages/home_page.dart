import 'package:aloha/components/pages/add_sales_page.dart';
import 'package:aloha/components/pages/broadcast_page.dart';
import 'package:aloha/components/pages/job_details_page.dart';
import 'package:aloha/components/pages/job_page.dart';
import 'package:aloha/components/pages/login_page.dart';
import 'package:aloha/components/pages/profile_page.dart';
import 'package:aloha/components/pages/start_message_page.dart';
import 'package:aloha/components/pages/template_page.dart';
import 'package:aloha/components/widgets/drawer.dart';
import 'package:aloha/components/widgets/messages/contact_list.dart';
import 'package:aloha/components/widgets/agents/sales_list.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/providers/sales_provider.dart';
import 'package:aloha/data/providers/user_provider.dart';
import 'package:aloha/utils/constants.dart';
import 'package:aloha/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:aloha/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedIndex = pesanLabel;
  String _title = pesanLabel;
  late UserProvider _provider;

  String _version = "";

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<UserProvider>(context, listen: false);
    PackageInfo.fromPlatform().then((value) => {_version = value.version});
  }

  setTitle(String newTitle) {
    setState(() {
      _title = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          title: Text(_title),
          actions: getAppBarActions(),
        ),
        drawer: AlohaDrawer(
          updateSelectedPage: (newSelectedIndex, newTitle) {
            setState(() {
              _selectedIndex = newSelectedIndex;
              _title = newTitle;
            });
          },
        ),
        body: getBody(),
        floatingActionButton: getFab(),
      ),
    );
  }

  FloatingActionButton? getFab() {
    switch (_selectedIndex) {
      case pesanLabel:
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StartMessagePage()));
          },
          child: const Icon(Icons.message),
        );
      case jobLabel:
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const JobDetailsPage(),
            ));
          },
          child: const Icon(Icons.add),
        );
      case salesLabel:
        return FloatingActionButton(
          onPressed: () {
            var provider = Provider.of<SalesProvider>(context, listen: false);
            provider.selectedAgent = null;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddSalesPage(),
            ));
          },
          child: const Icon(Icons.add),
        );
      default:
        return null;
    }
  }

  List<Widget>? getAppBarActions() {
    switch (_selectedIndex) {
      case pesanLabel:
        return [
          PopupMenuButton(
            shape: const RoundedRectangleBorder(borderRadius: alohaRadius),
            itemBuilder: (context) => [
              if (_provider.user.role == "admin")
                const PopupMenuItem(
                  child: Text("Broadcast Message"),
                  value: openBroadcastPage,
                ),
              const PopupMenuItem(
                child: Text("Template Pesan"),
                value: openTemplatePage,
              ),
            ],
            onSelected: (result) {
              if (result != null) {
                switch (result) {
                  case openBroadcastPage:
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const BroadcastPage(),
                    ));
                    break;
                  case openTemplatePage:
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TemplatePage(),
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

  Widget getBody() {
    switch (_selectedIndex) {
      case pesanLabel:
        return ContactList(
          setTitle: setTitle,
        );
      case salesLabel:
        return const SalesList();
      case jobLabel:
        return const JobPage();
      case profilLabel:
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
}
