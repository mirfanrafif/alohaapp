import 'package:aloha/data/providers/job_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/response/job.dart';

class JobFormPage extends StatefulWidget {
  const JobFormPage({Key? key}) : super(key: key);

  @override
  State<JobFormPage> createState() => _JobFormPageState();
}

class _JobFormPageState extends State<JobFormPage> {
  late JobProvider _provider;
  final _namaController = TextEditingController();
  final _descController = TextEditingController();
  Job? _job;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<JobProvider>(context, listen: false);
    _job = _provider.getJob();
    _namaController.text = _job?.name ?? "";
    _descController.text = _job?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobProvider>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Job Form",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Nama"),
                        controller: _namaController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Deskripsi"),
                        minLines: 1,
                        maxLines: 3,
                        controller: _descController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            value.saveJob(
                                _namaController.text, _descController.text);
                          },
                          child: const Text("Simpan"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Hapus Job"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red))),
              ),
            ],
          ),
        );
      },
    );
  }
}
