import 'package:aloha/data/providers/message_provider.dart';
import 'package:aloha/data/response/contact.dart';
import 'package:aloha/data/response/customer_categories.dart';
import 'package:aloha/data/response/message.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

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
  final _messageController = TextEditingController();

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
                  const Expanded(child: Text("Kategori Customer")),
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
                  const Expanded(child: Text("Minat Customer")),
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
              ),
              const SizedBox(
                height: 16,
              ),

              //customer interests
              Row(
                children: [
                  const Expanded(child: Text("Tipe Customer")),
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
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: "Pesan",
                  border: OutlineInputBorder(),
                ),
                minLines: 1,
                maxLines: 8,
              ),
            ],
          ),
        );
      }),
    );
  }
}
