import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class ProfilePicture extends StatelessWidget {
  final String? profilePhoto;
  const ProfilePicture({Key? key, this.profilePhoto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profilePhoto != null && profilePhoto!.isNotEmpty) {
      try {
        var imageUrl =
            "https://" + baseUrl + "/user/profile_image/" + profilePhoto!;
        return ClipOval(
          child: Container(
            color: Colors.black12,
            width: 40,
            height: 40,
            child: Image.network(
              imageUrl,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/image/user.png'),
            ),
          ),
        );
      } catch (e) {
        return ClipOval(
          child: Container(
              color: Colors.black12,
              width: 40,
              height: 40,
              child: Image.asset('assets/image/user.png')),
        );
      }
    } else {
      return ClipOval(
          child: Container(
              color: Colors.black12,
              width: 40,
              height: 40,
              child: Image.asset('assets/image/user.png')));
    }
  }
}
