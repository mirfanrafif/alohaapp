import 'package:aloha/data/providers/sales_provider.dart';
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
            child: Card(
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
                        height: 16,
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                            labelText: "Nama", border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: "Email", border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text("Role"),
                      DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedRole,
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
                                      ));
                            }
                          }),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
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
                          },
                          child: const Text('Simpan'),
                        ),
                      ),
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
