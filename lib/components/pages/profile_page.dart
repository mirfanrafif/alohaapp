import 'package:aloha/components/widgets/profile_picture.dart';
import 'package:aloha/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  late UserProvider _provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = _provider.user.fullName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ProfilePicture(
                    profilePhoto: value.user.profilePhoto,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nama",
                ),
                controller: _nameController),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Simpan"),
                onPressed: () async {
                  var response = await value.updateUser(_nameController.text);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(response.message)));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
