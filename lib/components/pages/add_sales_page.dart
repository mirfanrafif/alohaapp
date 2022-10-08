import 'package:aloha/components/widgets/button.dart';
import 'package:aloha/data/providers/sales_provider.dart';
import 'package:aloha/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSalesPage extends StatefulWidget {
  const AddSalesPage({Key? key}) : super(key: key);

  @override
  State<AddSalesPage> createState() => _AddSalesPageState();
}

class _AddSalesPageState extends State<AddSalesPage> {
  late SalesProvider provider;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _selectedRole = 'agent';

  @override
  void initState() {
    super.initState();
    provider = Provider.of<SalesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah sales baru")),
      body: Consumer<SalesProvider>(builder: (context, value, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: alohaRadius),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Data diri",
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: alohaInputDecoration("Nama"),
                      ),
                      height16,
                      TextField(
                        controller: _usernameController,
                        decoration: alohaInputDecoration("Username"),
                      ),
                      height16,
                      TextField(
                        controller: _emailController,
                        decoration: alohaInputDecoration("Email"),
                      ),
                      height16,
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: alohaInputDecoration("Password"),
                      ),
                      height16,
                      const Text("Role"),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: alohaInputColor,
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedRole,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                              child: Text('Admin'),
                              value: 'admin',
                            ),
                            DropdownMenuItem(
                              child: Text('Sales'),
                              value: 'agent',
                            ),
                          ],
                          onChanged: (newValue) {
                            if (newValue != null) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: const Text(
                                      'Apakah anda yakin ingin mengubah role?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedRole = newValue;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ya')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Batal')),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      height16,
                      alohaButton("Simpan", () {
                        provider
                            .addAgent(
                                _nameController.text,
                                _usernameController.text,
                                _emailController.text,
                                _selectedRole,
                                _passwordController.text)
                            .then((value) {
                          if (value.success) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(value.message)));
                          }
                        });
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
