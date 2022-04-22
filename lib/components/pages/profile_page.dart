import 'package:aloha/components/widgets/profile_picture.dart';
import 'package:aloha/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    super.initState();
    _provider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = _provider.user.fullName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ProfilePicture(
                            profilePhoto: value.user.profilePhoto,
                          ),
                        ),
                        IconButton(
                          onPressed: updateProfilePicture,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: " + value.user.email),
                        const SizedBox(
                          height: 8,
                        ),
                        Text("Username: " + value.user.username),
                        const SizedBox(
                          height: 8,
                        ),
                        Text("Role: " + value.user.role),
                      ],
                    ))
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
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text("Simpan"),
                    onPressed: () async {
                      var response =
                          await value.updateUser(_nameController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message)));
                    },
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    child: const Text("Ubah Password"),
                    onPressed: () async {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateProfilePicture() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      //tutup bottom sheet
      _provider.updateProfilePicture(image, context);
    }
  }
}
