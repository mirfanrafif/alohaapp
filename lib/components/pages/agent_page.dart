import 'package:aloha/components/widgets/agents/agent_profile.dart';
import 'package:aloha/components/widgets/agents/agent_statistics.dart';
import 'package:flutter/material.dart';

import '../../data/response/contact.dart';

class AgentPage extends StatefulWidget {
  final User agent;
  const AgentPage({Key? key, required this.agent}) : super(key: key);

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  int _selectedView = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Sales"),
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedView,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profil",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.line_axis), label: "Statistik")
        ],
        onTap: (index) {
          setState(() {
            _selectedView = index;
          });
        },
      ),
    );
  }

  Widget getBody() {
    switch (_selectedView) {
      case 0:
        return const AgentProfile();
      case 1:
        return const AgentStatistics();
      default:
        return Container();
    }
  }
}
