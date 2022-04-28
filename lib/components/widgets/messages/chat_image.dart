import 'package:flutter/material.dart';

import '../../../data/response/message.dart';
import '../../pages/image_page.dart';

class ChatImage extends StatelessWidget {
  final MessageEntity message;
  const ChatImage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ImagePage(message: message),
            ));
          },
          child: Image.network(
            message.file ?? "",
            // width: 300,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text("Tidak dapat memuat gambar " + (message.file ?? "")),
            ),
          ),
        ),
      ),
    );
  }
}
