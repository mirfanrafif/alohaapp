import 'dart:convert';
import 'dart:io';
import 'package:aloha/data/response/start_conversation_response.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '../response/contact.dart';
import '../response/message.dart';

class MessageService {
  Future<List<MessageEntity>> getPastMessages({
    required int customerId,
    int lastMessageId = 0,
    bool loadMore = false,
    required String token,
  }) async {
    try {
      var response = await get(
          Uri.https(baseUrl, "/message/${customerId.toString()}",
              loadMore ? {'last_message_id': lastMessageId.toString()} : {}),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        var data = messageResponseFromJson(response.body);
        return data.data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<ApiResponse<List<Contact>>> getAllContact(
      String token, String search) async {
    var response = await get(Uri.https(baseUrl, "/message", {'search': search}),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode < 400) {
      var data = ContactResponse.fromJson(jsonDecode(response.body));
      return ApiResponse(success: true, data: data.data, message: data.message);
    } else {
      var data = ApiErrorResponse.fromJson(jsonDecode(response.body));
      return ApiResponse(success: false, data: [], message: data.message);
    }
  }

  Future<List<MessageEntity>> sendMessage({
    required String customerNumber,
    required String message,
    required String token,
  }) async {
    try {
      var response = await post(Uri.https(baseUrl, "/message"),
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

  Future<ApiResponse<List<MessageEntity>?>> sendImage(
      {required XFile file,
      required String message,
      required String customerNumber,
      required String token}) async {
    try {
      var request =
          MultipartRequest('POST', Uri.https(baseUrl, "/message/image"));
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
        return ApiResponse(
            success: true,
            data: data.data,
            message: 'Success sending video to customer');
      } else {
        return ApiResponse(success: false, data: null, message: response);
      }
    } catch (e) {
      return ApiResponse(success: false, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<List<MessageEntity>?>> sendVideo(
      {required XFile file,
      required String message,
      required String customerNumber,
      required String token}) async {
    try {
      var request =
          MultipartRequest('POST', Uri.https(baseUrl, "/message/video"));
      request.headers.addAll({'Authorization': 'Bearer $token'});

      //add file request
      request.files.add(MultipartFile.fromBytes(
          'video', await file.readAsBytes(),
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
        return ApiResponse(
            success: true,
            data: data.data,
            message: 'Success sending video to customer');
      } else {
        var data = ApiErrorResponse.fromJson(jsonDecode(response));
        return ApiResponse(success: false, data: null, message: data.message);
      }
    } catch (e) {
      return ApiResponse(success: false, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<List<Customer>?>> searchCustomerFromCrm(
      String keyword, String token) async {
    var response = await get(
        Uri.https(baseUrl, "/customer", {'search': keyword}),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode < 400) {
      Map<String, dynamic> data = jsonDecode(response.body);
      var customers = List<Customer>.from(
          data['data'].map((item) => Customer.fromJson(item)));
      return ApiResponse(
          success: true,
          data: customers,
          message: 'Success searching customer from CRM');
    } else {
      var data = ApiErrorResponse.fromJson(jsonDecode(response.body));
      return ApiResponse(success: false, data: null, message: data.message);
    }
  }

  Future<ApiResponse<List<MessageEntity>>> sendDocument(
      {required File file,
      required String customerNumber,
      required String token}) async {
    try {
      var request =
          MultipartRequest('POST', Uri.https(baseUrl, "/message/document"));
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
        return ApiResponse(
            success: true, data: data.data, message: 'Sukses mengirim dokumen');
      } else {
        return ApiResponse(
            success: false,
            data: [],
            message: 'Gagal mengirim pesan: ' + response);
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: [],
          message: 'Gagal mengirim pesan: ' + e.toString());
    }
  }

  Future<ApiResponse<StartConversationResponse?>> startConversation(
      int customerId, String token) async {
    try {
      var response = await post(
          Uri.https(baseUrl, '/customer/$customerId/start'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode < 400) {
        var data =
            StartConversationResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: data,
            message:
                'Success start conversation with customer ${data.data?.customer?.name}');
      } else {
        var responseBody = ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false, data: null, message: responseBody.message);
      }
    } catch (e) {
      return ApiResponse(success: false, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<StartConversationResponse?>> assignCustomerToSales(
      int customerId, int salesId, String token) async {
    try {
      var request = jsonEncode({'customerId': customerId, 'agentId': salesId});
      var response = await post(Uri.https(baseUrl, '/customer/delegate'),
          body: request,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      if (response.statusCode < 400) {
        var data =
            StartConversationResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true, data: data, message: data.message ?? "");
      } else {
        var responseBody = ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false, data: null, message: responseBody.message);
      }
    } catch (e) {
      return ApiResponse(success: false, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<StartConversationResponse?>> unassignCustomerToSales(
      int customerId, int salesId, String token) async {
    try {
      var request = jsonEncode({'customerId': customerId, 'agentId': salesId});
      var response = await post(Uri.https(baseUrl, '/customer/undelegate'),
          body: request,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      if (response.statusCode < 400) {
        var data =
            StartConversationResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true, data: data, message: data.message ?? "");
      } else {
        var responseBody = ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false, data: null, message: responseBody.message);
      }
    } catch (e) {
      return ApiResponse(success: false, data: null, message: e.toString());
    }
  }

  Future<void> downloadFile(String url) async {
    List<int> downloadData = [];

    var httpClient = HttpClient();
    var filename = url.split('/').last;
    var fileSave = File('./$filename');

    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();

    response.listen((event) {
      downloadData.addAll(event);
    }, onDone: () {
      fileSave.writeAsBytes(downloadData);
    });
  }
}
