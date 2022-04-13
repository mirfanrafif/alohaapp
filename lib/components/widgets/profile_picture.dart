import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class ProfilePicture extends StatelessWidget {
  final String? profilePhoto;
  const ProfilePicture({Key? key, this.profilePhoto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profilePhoto != null && profilePhoto!.isNotEmpty) {
      var imageUrl =
          "https://" + BASE_URL + "/user/profile_image/" + profilePhoto!;
      return CircleAvatar(
        foregroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.black12,
        onForegroundImageError: (o, e) {
          print(e);
        },
      );
    } else {
      return const CircleAvatar(
        foregroundImage: AssetImage('assets/image/user.png'),
        backgroundColor: Colors.black12,
      );
    }
  }
}
