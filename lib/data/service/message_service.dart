import 'dart:convert';

import 'package:http/http.dart';

import '../response/Contact.dart';
import '../response/Message.dart';

class MessageService {
  Future<List<Message>> getPastMessages(
      {required int customerId,
      int lastMessageId = 0,
      bool loadMore = false}) async {
    var response = await get(
        Uri.https("dev.mirfanrafif.me", "/message/${customerId.toString()}",
            loadMore ? {'last_message_id': lastMessageId.toString()} : {}),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNjQ4NzI4MDk5LCJleHAiOjE2NDg4MTQ0OTl9.l5_JOlx3pExOsN7i5gaPTfKX0uLziO8qu91AdyEg6Ew'
        });
    if (response.statusCode == 200) {
      var data = messageResponseFromJson(response.body);
      return data.data;
    } else {
      return [];
    }
  }

  Future<List<Contact>> getAllContact() async {
    try {
      var response =
          await get(Uri.https("dev.mirfanrafif.me", "/message"), headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNjQ4NzQyNjUzLCJleHAiOjE2NDg4MjkwNTN9.rc7grHBS8gfPIlHj8Sc2FOiEx3_O4RTEIQ6FS5WwfBE'
      });
      if (response.statusCode == 200) {
        var data = ContactResponse.fromJson(jsonDecode(response.body));
        return data.data;
      } else {
        print(response.body);
        return [];
      }
    } catch (e) {
      print("Error: " + e.toString());
      return [];
    }
  }

  Future<List<Message>> sendMessage(
      {required String customerNumber, required String message}) async {
    try {
      var response =
          await post(Uri.https("dev.mirfanrafif.me", "/message"), body: {
        'customerNumber': customerNumber,
        'message': message
      }, headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNjQ4NzQyNjUzLCJleHAiOjE2NDg4MjkwNTN9.rc7grHBS8gfPIlHj8Sc2FOiEx3_O4RTEIQ6FS5WwfBE'
      });
      if (response.statusCode == 200) {
        var data = messageResponseFromJson(response.body);
        return data.data;
      } else {
        print(response.body);
        return [];
      }
    } catch (e) {
      print("Error: " + e.toString());
      return [];
    }
  }
}
