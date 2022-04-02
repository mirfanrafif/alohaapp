import 'package:aloha/components/pages/login_page.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var user = await userProvider.getUser();
    if(user.username.isNotEmpty) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
            (route) => false,
      );
    }else{
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(60),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Image(image: AssetImage('assets\\image\\empty_message_bg.png')),
              Text("Halo, selamat datang", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
