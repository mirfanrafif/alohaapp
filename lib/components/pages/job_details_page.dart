import 'package:aloha/components/widgets/job_form.dart';
import 'package:flutter/material.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({Key? key}) : super(key: key);

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Job')),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Job"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Sales"),
        ],
        onTap: (newValue) {
          setState(() {
            _selectedPage = newValue;
          });
        },
      ),
    );
  }

  Widget getBody() {
    switch (_selectedPage) {
      case 0:
        return const JobFormPage();
      default:
        return Container();
    }
  }
}
