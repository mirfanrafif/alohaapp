import 'package:aloha/data/response/Contact.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';

class ContactService extends ChangeNotifier {
  final List<Contact> _contactList = [];

  var loading = false;

  ContactService() {
    getAllContact();
  }

  List<Contact> get contacts => _contactList;
  setContact(List<Contact> newContact) {
    contacts.clear();
    contacts.addAll(newContact);
    loading = false;
    notifyListeners();
  }

  Future<List<Contact>> getAllContact() async {
    try {
      var response =
          await get(Uri.https("dev.mirfanrafif.me", "/message"), headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNjQ4NjQxNDU3LCJleHAiOjE2NDg3Mjc4NTd9.hBNS-iSlih0p5RHDyIQ1KAje4O2IMqgATTvJkAiRL2o'
      });
      if (response.statusCode == 200) {
        var data = ContactResponse.fromJson(jsonDecode(response.body));
        setContact(data.data);
        return data.data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
