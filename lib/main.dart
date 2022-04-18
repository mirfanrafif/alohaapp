import 'package:aloha/components/pages/home_page.dart';
import 'package:aloha/components/pages/login_page.dart';
import 'package:aloha/data/preferences/base_preferences.dart';
import 'package:aloha/data/providers/job_provider.dart';
import 'package:aloha/data/providers/sales_provider.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BasePreferences.init();
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        ),
        home: Consumer<UserProvider>(
          builder: (context, provider, child) =>
              provider.token.isNotEmpty ? const HomePage() : const LoginPage(),
        ),
      ),
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SalesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => JobProvider(),
        ),
      ],
    );
  }
}
