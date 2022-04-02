import 'package:aloha/components/pages/home_page.dart';
import 'package:aloha/components/pages/login_page.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/providers/user_provider.dart';
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
          primarySwatch: Colors.deepOrange,
        ),
        home: const LoginPage(),
      ),
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
      ],
    );
  }
}
