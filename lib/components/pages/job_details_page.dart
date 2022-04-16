import 'package:aloha/components/widgets/job_form.dart';
import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Job')),
      body: const JobFormPage(),
    );
  }
}
