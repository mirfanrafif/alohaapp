import 'package:aloha/data/response/Contact.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';

class ContactProvider extends ChangeNotifier {
  final List<Contact> _contactList = [];

  var loading = false;

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
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNjQ4NzI4MDk5LCJleHAiOjE2NDg4MTQ0OTl9.l5_JOlx3pExOsN7i5gaPTfKX0uLziO8qu91AdyEg6Ew'
      });
      if (response.statusCode == 200) {
        var data = ContactResponse.fromJson(jsonDecode(response.body));
        setContact(data.data);
        return data.data;
      } else {
        print(response.body);
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
