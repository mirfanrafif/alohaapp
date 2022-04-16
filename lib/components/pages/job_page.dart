import 'package:aloha/components/pages/job_details_page.dart';
import 'package:aloha/data/providers/job_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobPage extends StatefulWidget {
  const JobPage({Key? key}) : super(key: key);

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JobProvider>(builder: (context, value, child) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text(value.jobs?[index].name ?? ""),
                subtitle: Text(value.jobs?[index].description ?? ""),
                onTap: () {
                  value.selectedJobId = value.jobs?[index].id;
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const JobDetailsPage(),
                  ));
                },
              ),
              itemCount: value.jobs?.length ?? 0,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  value.selectedJobId = null;
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const JobDetailsPage(),
                  ));
                },
                child: const Text('Tambah Job')),
          )
        ],
      );
    });
  }
}
