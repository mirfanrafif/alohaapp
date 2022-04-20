import 'package:aloha/data/providers/job_provider.dart';
import 'package:aloha/data/response/job.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobDetailsPage extends StatefulWidget {
  final Job? job;
  const JobDetailsPage({Key? key, this.job}) : super(key: key);

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  late JobProvider _provider;
  final _namaController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<JobProvider>(context, listen: false);
    _namaController.text = widget.job?.name ?? "";
    _descController.text = widget.job?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Job')),
      body: Consumer<JobProvider>(
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
                            onPressed: () async {
                              var response = await value.saveJob(
                                  _namaController.text,
                                  _descController.text,
                                  widget.job?.id);
                              if (response.success) {
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response.message)));
                              }
                            },
                            child: const Text("Simpan"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: const Text("Apakah anda yakin ingin menghapus job ini?"),
              actions: [
                TextButton(
                  onPressed: () async {
                    var response = await _provider.deleteJob(widget.job?.id);
                    if (response.success) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message)));
                    }
                  },
                  child: const Text("Ya"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Batal"),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}
