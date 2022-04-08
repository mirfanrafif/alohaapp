import 'dart:io';

import 'package:aloha/components/pages/send_image_page.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/response/Contact.dart';

class ChatInput extends StatefulWidget {
  final Customer customer;

  const ChatInput({Key? key, required this.customer}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  var chatController = TextEditingController();
  var _currentChat = '';
  late MessageProvider provider;

  @override
  void initState() {
    super.initState();
    chatController.addListener(() {
      setState(() {
        _currentChat = chatController.text;
      });
    });
    provider = Provider.of<MessageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

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
          customer: widget.customer,
          message: _currentChat,
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
          customer: widget.customer,
          message: _currentChat,
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

      provider.sendDocument(
          file: file, customerNumber: widget.customer.phoneNumber);
    } else {
      // User canceled the picker
    }
  }

  void sendMessage() {
    Provider.of<MessageProvider>(context, listen: false).sendMessage(
        customerNumber: widget.customer.phoneNumber, message: _currentChat);
    chatController.clear();
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
