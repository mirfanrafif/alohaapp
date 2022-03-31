import 'package:aloha/components/pages/home_page.dart';
import 'package:aloha/data/service/contact_service.dart';
import 'package:aloha/data/service/message_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'Aloha',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const HomePage(),
      ),
      providers: [
        ChangeNotifierProvider(create: (context) => ContactService()),
        ChangeNotifierProvider(create: (context) => MessageService())
      ],
    );
  }
}
