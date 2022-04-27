import 'package:aloha/data/response/message.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:url_launcher/url_launcher.dart';

class ImagePage extends StatelessWidget {
  final MessageEntity message;
  const ImagePage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.customer.name,
            ),
            Text(
              message.customer.phoneNumber,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var _url = Uri.parse(message.file ?? "");
                if (!await launchUrl(_url,
                    mode: LaunchMode.externalApplication)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch $_url')));
                }
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            PinchZoom(
              child: Image(
                image: NetworkImage(message.file ?? ""),
              ),
              maxScale: 2.5,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                color: Colors.black54,
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
