import 'package:aloha/components/pages/agent_page.dart';
import 'package:aloha/components/widgets/profile_picture.dart';
import 'package:aloha/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesList extends StatefulWidget {
  const SalesList({Key? key}) : super(key: key);

  @override
  State<SalesList> createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  late SalesProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<SalesProvider>(context, listen: false);
    _provider.init(context);
  }

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
                  ? Text(agent.job!.map((e) => e.job.name).join(','))
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
