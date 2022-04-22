import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/sales_provider.dart';

class AgentProfile extends StatefulWidget {
  const AgentProfile({Key? key}) : super(key: key);

  @override
  State<AgentProfile> createState() => _AgentProfileState();
}

class _AgentProfileState extends State<AgentProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ListView(
        children: const [
          SalesEditForm(),
          SizedBox(
            height: 16,
          ),
          SalesJobDropdown()
        ],
      ),
    );
  }
}

class SalesEditForm extends StatefulWidget {
  const SalesEditForm({Key? key}) : super(key: key);

  @override
  State<SalesEditForm> createState() => _SalesEditFormState();
}

class _SalesEditFormState extends State<SalesEditForm> {
  late SalesProvider provider;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    provider = Provider.of<SalesProvider>(context, listen: false);
    if (provider.selectedAgent != null) {
      _nameController.text = provider.selectedAgent!.fullName;
      _usernameController.text = provider.selectedAgent!.username;
      _emailController.text = provider.selectedAgent!.email;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, value, child) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Data diri",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nama"),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(
                  height: 8,
                ),
                DropdownButton<String>(
                    isExpanded: true,
                    value: provider.selectedAgent?.role,
                    items: const [
                      DropdownMenuItem(
                        child: Text('Admin'),
                        value: 'admin',
                      ),
                      DropdownMenuItem(
                        child: Text('Sales'),
                        value: 'agent',
                      ),
                    ],
                    onChanged: (newValue) {
                      if (newValue != null) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: const Text(
                                      'Apakah anda yakin ingin mengubah role?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          provider
                                              .setSelectedAgentRole(newValue);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ya')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Batal')),
                                  ],
                                ));
                      }
                    }),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      value
                          .updateAgents(_nameController.text,
                              _usernameController.text, _emailController.text)
                          .then((value) {
                        if (value.success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(value.message)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(value.message)));
                        }
                      });
                    },
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SalesJobDropdown extends StatefulWidget {
  const SalesJobDropdown({Key? key}) : super(key: key);

  @override
  State<SalesJobDropdown> createState() => _SalesJobDropdownState();
}

class _SalesJobDropdownState extends State<SalesJobDropdown> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, provider, child) {
        var jobs = provider.selectedAgentJob;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Job",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 16,
                ),
                ...provider.jobs
                    .map((job) => Row(
                          children: [
                            Checkbox(
                                value: jobs.indexWhere(
                                        (element) => element.id == job.id) >
                                    -1,
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    provider.setSelectedAgentJob(
                                        newValue, job, context);
                                  }
                                }),
                            Expanded(
                              child: Text(job.name),
                            )
                          ],
                        ))
                    .toList()
              ],
            ),
          ),
        );
      },
    );
  }
}
