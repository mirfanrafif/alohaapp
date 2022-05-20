import 'dart:io';

import 'package:aloha/components/pages/send_image_page.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../data/response/contact.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({Key? key}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  var chatController = TextEditingController();
  late MessageProvider provider;
  late Customer customer;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MessageProvider>(context, listen: false);
    customer = provider.getSelectedCustomer().customer;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...provider.templates
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () {
                              chatController.text = e.template ?? "";
                            },
                            child: Chip(
                              backgroundColor: Colors.amber.shade300,
                              label: Text(e.name ?? ""),
                            ),
                          ),
                        ))
                    .toList()
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: chatController,
                  decoration: InputDecoration(
                      hintText: "Tulis pesan disini...",
                      contentPadding: const EdgeInsets.all(8),
                      prefixIcon: IconButton(
                        onPressed: showDialog,
                        icon: const Icon(Icons.attachment),
                      ),
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                      fillColor: Colors.white),
                  minLines: 1,
                  maxLines: 5,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32),
                  ),
                  color: canSend ? Colors.green : Colors.grey,
                  boxShadow: const [
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
        ],
      ),
    );
  }

  bool canSend = true;

  InputBorder inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Colors.black12),
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  );

  void showDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Upload Lampiran",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AttachmentButton(
                    color: Colors.orange,
                    onTap: takePictureFromCamera,
                    icon: const Icon(Icons.camera),
                    label: "Camera"),
                AttachmentButton(
                  color: Colors.blue,
                  onTap: pickFromGallery,
                  icon: const Icon(Icons.photo),
                  label: "Gallery",
                ),
                AttachmentButton(
                  color: Colors.cyan.shade400,
                  onTap: pickVideoFromGallery,
                  icon: const Icon(Icons.video_camera_back),
                  label: "Video",
                ),
                AttachmentButton(
                  color: Colors.lightGreen,
                  onTap: uploadDocument,
                  icon: const Icon(Icons.upload_file),
                  label: "Document",
                ),
              ],
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
    );
  }

  void pickFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      //tutup bottom sheet
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SendImagePage(
          file: image,
          customer: customer,
          message: chatController.text,
          type: "image",
        ),
      ));
    }
  }

  void pickVideoFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickVideo(source: ImageSource.gallery);

    if (image != null) {
      //tutup bottom sheet
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SendImagePage(
          file: image,
          customer: customer,
          message: chatController.text,
          type: "video",
        ),
      ));
    }
  }

  void takePictureFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      //tutup bottom sheet
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SendImagePage(
          file: image,
          customer: customer,
          message: chatController.text,
          type: "image",
        ),
      ));
    }
  }

  uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path ?? "");
      //tutup bottom sheet
      Navigator.pop(context);
      setState(() {
        canSend = false;
      });

      provider
          .sendDocument(file: file, customerNumber: customer.phoneNumber)
          .then((value) {
        if (!value.success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value.message),
          ));
        }
        setState(() {
          canSend = true;
        });
      });
    } else {
      // User canceled the picker
    }
  }

  void sendMessage() async {
    if (chatController.text.isNotEmpty && canSend) {
      setState(() {
        canSend = false;
      });
      await provider.sendMessage(
          customerNumber: customer.phoneNumber, message: chatController.text);
      chatController.clear();
      setState(() {
        canSend = true;
      });
    }
  }
}

class AttachmentButton extends StatelessWidget {
  final Color color;
  final Function() onTap;
  final Icon icon;
  final String label;
  const AttachmentButton({
    required this.color,
    required this.onTap,
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: ClipOval(
            child: Material(
              color: color,
              child: InkWell(
                splashColor: Colors.green,
                onTap: onTap,
                child: icon,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(label),
      ],
    );
  }
}
