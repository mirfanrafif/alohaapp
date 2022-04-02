import 'dart:convert';

import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';

import '../response/Contact.dart';
import '../response/Message.dart';

class MessageService {
  Future<List<Message>> getPastMessages({
    required int customerId,
    int lastMessageId = 0,
    bool loadMore = false,
    required String token,
  }) async {
    var response = await get(
        Uri.https(BASE_URL, "/message/${customerId.toString()}",
            loadMore ? {'last_message_id': lastMessageId.toString()} : {}),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = messageResponseFromJson(response.body);
      return data.data;
    } else {
      return [];
    }
  }

  Future<List<Contact>> getAllContact(String token) async {
    try {
      var response = await get(Uri.https(BASE_URL, "/message"),
          headers: {'Authorization': 'Bearer $token'});
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

  Future<List<Message>> sendMessage({
    required String customerNumber,
    required String message,
    required String token,
  }) async {
    try {
      var response = await post(Uri.https(BASE_URL, "/message"),
          body: {'customerNumber': customerNumber, 'message': message},
          headers: {'Authorization': 'Bearer $token'});
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
