import 'package:aloha/data/response/Message.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImagePage extends StatelessWidget {
  final Message message;
  const ImagePage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.customer.name),
            Text(
              message.customer.phoneNumber,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            Expanded(
              child: PinchZoom(
                child: Image(
                  image: NetworkImage(message.fromMe
                      ? "https://dev.mirfanrafif.me/message/image/${message.file}"
                      : "https://solo.wablas.com/image/${message.file}"),
                ),
                maxScale: 2.5,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(
                  message.message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
