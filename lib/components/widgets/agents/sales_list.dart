import 'package:aloha/components/pages/agent_page.dart';
import 'package:aloha/components/widgets/profile_picture.dart';
import 'package:aloha/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesList extends StatelessWidget {
  const SalesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            var agent = provider.agents[index];
            return ListTile(
              leading: ProfilePicture(profilePhoto: agent.profilePhoto),
              title: Text(agent.fullName),
              subtitle: agent.job != null
                  ? Text(agent.job!.name)
                  : const Text(
                      "Belum ada job",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
              onTap: () {
                provider.selectedAgent = agent;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AgentPage(
                    agent: agent,
                  ),
                ));
              },
            );
          },
          itemCount: provider.agents.length,
        );
      },
    );
  }
}