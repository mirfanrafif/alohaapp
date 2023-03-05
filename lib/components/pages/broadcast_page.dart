import 'dart:io';

import 'package:aloha/components/widgets/messages/chat_input.dart';
import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/response/customer_categories.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({Key? key}) : super(key: key);

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final List<CustomerCategories> _selectedCategories = [];
  final List<CustomerInterests> _selectedInterests = [];
  final List<CustomerTypes> _selectedTypes = [];
  late MessageProvider _provider;
  String status = "Kontak";
  final _messageController = TextEditingController();
  File? file;
  String type = "text";
  VideoPlayerController? _controller;

  bool messageEnabled = true;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<MessageProvider>(context, listen: false);
    _provider.getCategoriesTypesInterests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Broadcast Pesan")),
      body: Consumer<MessageProvider>(builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Row(
                children: [
                  const Expanded(child: Text("Kategori Pelanggan")),
                  TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SizedBox(
                            child: MultiSelectBottomSheet<CustomerCategories>(
                              items: provider.categories
                                  .map((e) =>
                                      MultiSelectItem<CustomerCategories>(
                                          e, e.name ?? ""))
                                  .toList(),
                              initialValue: _selectedCategories,
                              searchable: true,
                              listType: MultiSelectListType.CHIP,
                              onConfirm: (selected) {
                                setState(() {
                                  _selectedCategories.clear();
                                  _selectedCategories.addAll(selected);
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text("Pilih Kategori")),
                ],
              ),
              MultiSelectChipDisplay<CustomerCategories>(
                chipColor: Colors.blue.shade100,
                textStyle: const TextStyle(color: Colors.black),
                items: _selectedCategories
                    .map((e) =>
                        MultiSelectItem<CustomerCategories>(e, e.name ?? ""))
                    .toList(),
              ),
              const SizedBox(
                height: 16,
              ),

              //customer interests
              Row(
                children: [
                  const Expanded(child: Text("Minat Pelanggan")),
                  TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SizedBox(
                            child: MultiSelectBottomSheet<CustomerInterests>(
                              items: provider.interests
                                  .map((e) =>
                                      MultiSelectItem<CustomerInterests>(
                                          e, e.name ?? ""))
                                  .toList(),
                              initialValue: _selectedInterests,
                              searchable: true,
                              listType: MultiSelectListType.CHIP,
                              onConfirm: (selected) {
                                setState(() {
                                  _selectedInterests.clear();
                                  _selectedInterests.addAll(selected);
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text("Pilih Minat")),
                ],
              ),
              MultiSelectChipDisplay<CustomerInterests>(
                items: _selectedInterests
                    .map((e) =>
                        MultiSelectItem<CustomerInterests>(e, e.name ?? ""))
                    .toList(),
                chipColor: Colors.orange.shade100,
                textStyle: const TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 16,
              ),

              //customer interests
              Row(
                children: [
                  const Expanded(child: Text("Tipe Pelanggan")),
                  TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SizedBox(
                            child: MultiSelectBottomSheet<CustomerTypes>(
                              items: provider.types
                                  .map((e) => MultiSelectItem<CustomerTypes>(
                                      e, e.name ?? ""))
                                  .toList(),
                              initialValue: _selectedTypes,
                              searchable: true,
                              listType: MultiSelectListType.CHIP,
                              onConfirm: (selected) {
                                setState(() {
                                  _selectedTypes.clear();
                                  _selectedTypes.addAll(selected);
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text("Pilih Minat")),
                ],
              ),
              MultiSelectChipDisplay<CustomerTypes>(
                items: _selectedTypes
                    .map((e) => MultiSelectItem<CustomerTypes>(e, e.name ?? ""))
                    .toList(),
                chipColor: Colors.green.shade100,
                textStyle: const TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 16,
              ),

              const Text(
                "Status Pelanggan",
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                child: DropdownButton<String>(
                    isExpanded: true,
                    items: ["Kontak", "Prospek Kontak", "Blacklist Kontak"]
                        .map((e) => DropdownMenuItem<String>(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    value: status,
                    onChanged: (selected) {
                      setState(() {
                        status = selected ?? "Kontak";
                      });
                    }),
                width: double.infinity,
              ),

              const SizedBox(
                height: 16,
              ),
              //Text
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: "Pesan",
                  border: OutlineInputBorder(),
                ),
                minLines: 1,
                maxLines: 8,
                enabled: messageEnabled,
              ),
              const SizedBox(
                height: 16,
              ),
              OutlinedButton(
                  onPressed: showDialog,
                  child:
                      Text(file != null ? "Ubah Lampiran" : "Tambah Lampiran")),
              getPreview(),
              ElevatedButton(
                  onPressed: () {
                    provider.sendBroadcastMessage(
                        _selectedCategories,
                        _selectedInterests,
                        _selectedTypes,
                        status,
                        _messageController.text,
                        type,
                        file,
                        context);
                  },
                  child: const Text("Kirim Broadcast"))
            ],
          ),
        );
      }),
    );
  }

  Widget getPreview() {
    switch (type) {
      case "document":
        return SizedBox(
          height: 200,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(file?.path.split('/').last ?? ""),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    type = "text";
                    file = null;
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
      case "image":
        return SizedBox(
          height: 200,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.file(
                file!,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    type = "text";
                    file = null;
                    messageEnabled = true;
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
      case "video":
        return SizedBox(
          height: 200,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!)),
              IconButton(
                onPressed: () {
                  setState(() {
                    type = "text";
                    file = null;
                    messageEnabled = true;
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
      default:
        return const SizedBox(
          height: 200,
          width: 300,
          child: Center(
            child: Text("Tidak ada lampiran"),
          ),
        );
    }
  }

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
      setState(() {
        type = "image";
        messageEnabled = true;
        file = File(image.path);
      });
    }
  }

  void pickVideoFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickVideo(source: ImageSource.gallery);

    if (image != null) {
      //tutup bottom sheet
      Navigator.pop(context);
      setState(() {
        type = "video";
        messageEnabled = true;
        file = File(image.path);
        _controller = VideoPlayerController.file(file!)
          ..initialize().then((value) {});
      });
    }
  }

  void takePictureFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      //tutup bottom sheet
      Navigator.pop(context);
      setState(() {
        type = "image";
        messageEnabled = true;
        file = File(image.path);
      });
    }
  }

  uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      //tutup bottom sheet
      Navigator.pop(context);
      setState(() {
        type = "document";
        messageEnabled = false;
        file = File(result.files.single.path ?? "");
      });
    } else {
      // User canceled the picker
    }
  }
}
