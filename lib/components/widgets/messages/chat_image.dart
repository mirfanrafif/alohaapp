import 'package:flutter/material.dart';

import '../../../data/response/Message.dart';
import '../../pages/image_page.dart';

class ChatImage extends StatelessWidget {
  final Message message;
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
          child: Image(
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return SizedBox(
                height: 200,
                width: 300,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            image: NetworkImage(message.fromMe
                ? "https://dev.mirfanrafif.me/message/image/${message.file}"
                : "https://solo.wablas.com/image/${message.file}"),
            height: 200,
            width: 300,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
