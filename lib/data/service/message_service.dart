import 'dart:convert';
import 'dart:io';
import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '../response/contact.dart';
import '../response/Message.dart';

class MessageService {
  Future<List<Message>> getPastMessages({
    required int customerId,
    int lastMessageId = 0,
    bool loadMore = false,
    required String token,
  }) async {
    try {
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
    } catch (e) {
      print(e.toString());
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
        return [];
      }
    } catch (e) {
      print(e.toString());
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
      if (response.statusCode < 400) {
        var data = messageResponseFromJson(response.body);
        return data.data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Message>> sendImage(
      {required XFile file,
      required String message,
      required String customerNumber,
      required String token}) async {
    try {
      var request =
          MultipartRequest('POST', Uri.https(BASE_URL, "/message/image"));
      request.headers.addAll({'Authorization': 'Bearer $token'});

      //add file request
      request.files.add(MultipartFile.fromBytes(
          'image', await file.readAsBytes(),
          filename: file.path.split('/').last));

      //add customer number to request
      request.fields['customerNumber'] = customerNumber;

      //add message to request
      request.fields['message'] = message;

      var streamedResponse = await request.send();
      var responseBytes = await streamedResponse.stream.toBytes();
      var response = utf8.decode(responseBytes.toList());
      if (streamedResponse.statusCode < 400) {
        var data = messageResponseFromJson(response);
        return data.data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Message>> sendDocument(
      {required File file,
      required String customerNumber,
      required String token}) async {
    try {
      var request =
          MultipartRequest('POST', Uri.https(BASE_URL, "/message/document"));
      request.headers.addAll({'Authorization': 'Bearer $token'});
      //add file request
      request.files.add(MultipartFile.fromBytes(
          'document', file.readAsBytesSync(),
          filename: file.path.split('/').last));

      //add customer number to request
      request.fields['customerNumber'] = customerNumber;

      //bentuk response nya StreamedResponse. jadinya harus dikonversi
      var streamedResponse = await request.send();
      var responseBytes = await streamedResponse.stream.toBytes();
      var response = utf8.decode(responseBytes.toList());
      if (streamedResponse.statusCode < 400) {
        var data = messageResponseFromJson(response);
        return data.data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
