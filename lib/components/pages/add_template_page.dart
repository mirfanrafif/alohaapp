import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/response/message_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTemplatePage extends StatefulWidget {
  final MessageTemplate? template;
  const AddTemplatePage({Key? key, this.template}) : super(key: key);

  @override
  State<AddTemplatePage> createState() => _AddTemplatePageState();
}

class _AddTemplatePageState extends State<AddTemplatePage> {
  final _nameController = TextEditingController();
  final _templateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.template?.name ?? "";
    _templateController.text = widget.template?.template ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form template")),
      body: Consumer<MessageProvider>(builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Nama"),
                controller: _nameController,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Template"),
                controller: _templateController,
                minLines: 1,
                maxLines: 8,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    provider
                        .saveTemplate(widget.template?.id, _nameController.text,
                            _templateController.text)
                        .then((value) {
                      if (!value.success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(value.message)));
                      } else {
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: const Text("Simpan Template"))
            ],
          ),
        );
      }),
    );
  }
}
