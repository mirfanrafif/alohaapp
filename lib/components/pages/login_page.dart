import 'package:aloha/components/pages/home_page.dart';
import 'package:aloha/data/providers/user_provider.dart';
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
      var snackBar = SnackBar(content: Text(response.message));
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
      body: Padding(
          padding: const EdgeInsets.all(30),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(32),
                child: Image.asset(
                  "assets\\image\\aloha_logo.png",
                ),
              ),
              const Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: "Username", border: OutlineInputBorder()),
                controller: _usernameController,
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text("Login"),
                ),
              )
            ],
          )),
    );
  }
}
