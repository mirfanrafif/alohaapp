import 'package:aloha/components/pages/home_page.dart';
import 'package:aloha/components/widgets/button.dart';
import 'package:aloha/data/providers/user_provider.dart';
import 'package:aloha/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  var _username = '';
  var _password = '';

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
  }

  Future<void> login() async {
    var response = await Provider.of<UserProvider>(context, listen: false)
        .login(username: _username, password: _password);
    if (response.success) {
      goToHomePage();
    } else {
      var snackBar = SnackBar(
          behavior: SnackBarBehavior.floating, content: Text(response.message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  goToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Image.asset(
                      "assets/image/aloha_logo.png",
                    ),
                  ),
                  const Text(
                    "Selamat Datang",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextField(
                    decoration: alohaInputDecoration("Username"),
                    controller: _usernameController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: alohaInputDecoration("Password"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  alohaButton("Login", login)
                ],
              )),
        ),
      ),
    );
  }
}
