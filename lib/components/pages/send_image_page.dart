import 'dart:io';

import 'package:aloha/data/response/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../data/providers/message_provider.dart';

class SendImagePage extends StatefulWidget {
  final XFile file;
  final Customer customer;
  final String message;
  final String type;
  const SendImagePage({
    Key? key,
    required this.file,
    required this.customer,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  State<SendImagePage> createState() => _SendImagePageState();
}

class _SendImagePageState extends State<SendImagePage> {
  var chatController = TextEditingController();
  var _currentChat = '';
  late MessageProvider provider;

  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _currentChat = widget.message;
    chatController.addListener(() {
      setState(() {
        _currentChat = chatController.text;
      });
    });
    _videoPlayerController = VideoPlayerController.file(File(widget.file.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    provider = Provider.of<MessageProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    chatController.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.customer.name,
            ),
            Text(
              widget.customer.phoneNumber,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              //jika file adalah video
              child: widget.type == "video"
                  //jika controller sudah di inisialisasi
                  ? _videoPlayerController.value.isInitialized
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio:
                                  _videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController.value.isPlaying
                                      ? _videoPlayerController.pause()
                                      : _videoPlayerController.play();
                                });
                              },
                              icon: Icon(
                                _videoPlayerController.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      //jika belum maka return container
                      : Container()

                  //jika file adalah gambar
                  : Image(
                      image: FileImage(
                        File(widget.file.path),
                      ),
                    ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatController,
                      decoration: InputDecoration(
                          hintText: "Tulis pesan disini...",
                          contentPadding: const EdgeInsets.all(8),
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          filled: true,
                          fillColor: Colors.white),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                      color: Colors.green,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    provider
        .sendImage(
      file: widget.file,
      customerNumber: widget.customer.phoneNumber,
      message: chatController.text,
      type: widget.type,
    )
        .then((response) {
      if (response.success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));
      }
    });
  }

  InputBorder inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Colors.white),
    borderRadius: BorderRadius.all(
      Radius.circular(16),
    ),
  );
}
