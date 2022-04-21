import 'package:aloha/components/pages/add_template_page.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Template pesan")),
      body: Consumer<MessageProvider>(builder: (context, provider, child) {
        return ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text(provider.templates[index].name ?? ""),
            subtitle: Text(provider.templates[index].template ?? ""),
            trailing: IconButton(
              onPressed: () {
                provider.deleteTemplate(provider.templates[index].id!);
              },
              icon: const Icon(Icons.delete),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AddTemplatePage(template: provider.templates[index]),
              ));
            },
          ),
          itemCount: provider.templates.length,
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddTemplatePage(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
