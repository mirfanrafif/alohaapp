import 'dart:io';

import 'package:aloha/data/preferences/user_preferences.dart';
import 'package:aloha/data/response/contact.dart';
import 'package:aloha/data/response/customer_categories.dart';
import 'package:aloha/data/response/message_template.dart';
import 'package:aloha/data/response/start_conversation_response.dart';
import 'package:aloha/data/service/broadcast_message_service.dart';
import 'package:aloha/data/service/message_service.dart';
import 'package:aloha/data/service/message_template_service.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart';

import '../models/customer_message.dart';
import '../response/message.dart';

class MessageProvider extends ChangeNotifier {
  List<CustomerMessage> _customerMessage = [];

  final MessageService _messageService = MessageService();
  final UserPreferences _preferences = UserPreferences();
  final BroadcastMessageService _broadcastMessageService =
      BroadcastMessageService();
  final MessageTemplateService _messageTemplateService =
      MessageTemplateService();
  late Socket socketClient;

  List<CustomerMessage> get customerMessage =>
      List.unmodifiable(_customerMessage);

  String _token = "";
  int _id = 0;
  bool initDone = false;

  Future<void> init(BuildContext context) async {
    initDone = true;
    _token = _preferences.getToken();
    var user = _preferences.getUser();
    _id = user.id;
    setupSocket();
    getTemplates(context);
    var response = await getAllContact();
    if (!response.success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));
    }
  }

  var _searchKeyword = "";

  String get searchKeyword => _searchKeyword;
  set searchKeyword(String newValue) {
    _searchKeyword = newValue;
    getAllContact();
    notifyListeners();
  }

  Future<ApiResponse<List<Customer>?>> searchNewCustomer(String keyword) async {
    return await _messageService.searchCustomerFromCrm(keyword, _token);
  }

  var chatLoading = false;

  List<Message> getMessageByCustomerId(int customerId) =>
      _customerMessage[findCustomerIndexById(customerId)].message;

  Future<ApiResponse<List<Contact>>> getAllContact() async {
    _customerMessage.clear();
    var value = await _messageService.getAllContact(_token, _searchKeyword);
    if (value.success && value.data != null) {
      mapContactToCustomerMessage(value.data!);
    }
    return value;
  }

  bool getIsAllLoaded(int customerId) {
    var index = findCustomerIndexById(customerId);
    return customerMessage[index].allLoaded;
  }

  void mapContactToCustomerMessage(List<Contact> contactList) {
    for (var contact in contactList) {
      _customerMessage.add(CustomerMessage(
        agents: contact.agent,
        customer: contact.customer,
        message: contact.lastMessage != null ? [contact.lastMessage!] : [],
        unread: contact.unread,
      ));
    }
    notifyListeners();
  }

  void logout() {
    _customerMessage.clear();
    _preferences.logout();
    initDone = false;
    socketClient.disconnect();
    notifyListeners();
  }

  void setupSocket() {
    try {
      socketClient = io(
          "https://" + baseUrl + "/messages",
          OptionBuilder()
              .setTransports(['websocket'])
              .enableReconnection()
              .build());

      socketClient.onConnectError((data) {
        if (data is WebSocketException) {
        } else if (data is SocketException) {
        } else {}
      });
      socketClient.onConnect((data) {
        var data = {'id': _id};
        socketClient.emit("join", jsonEncode(data));

        socketClient.on("message", (data) {
          processIncomingMessage(data);
        });
      });
    } catch (e) {}
  }

  processIncomingMessage(String data) {
    var incomingMessage = Message.fromJson(jsonDecode(data));
    var customerIndex = findCustomerIndexById(incomingMessage.customer.id);
    if (customerIndex == -1) {
      _customerMessage = [
        CustomerMessage(
            agents: [],
            customer: incomingMessage.customer,
            message: [incomingMessage],
            unread: 1),
        ..._customerMessage
      ];
    } else {
      //mencari index pesan
      var messageIndex = customerMessage[customerIndex]
          .message
          .indexWhere((element) => element.id == incomingMessage.id);
      if (messageIndex == -1) {
        //menerima pesan baru
        customerMessage[customerIndex].message = [
          incomingMessage,
          ...customerMessage[customerIndex].message
        ];

        //update unread nya
        if (incomingMessage.fromMe) {
          customerMessage[customerIndex].unread = 0;
        } else {
          customerMessage[customerIndex].unread++;
        }
      } else {
        //bagian ini cuma buat update tracking
        customerMessage[customerIndex].message[messageIndex].status =
            incomingMessage.status;
      }
    }

    notifyListeners();
    return data;
  }

  bool getIsFirstLoad(int customerId) {
    var customerIndex = findCustomerIndexById(customerId);
    return _customerMessage[customerIndex].firstLoad;
  }

  void setFirstLoadDone(int customerId) {
    var customerIndex = _customerMessage
        .indexWhere((element) => element.customer.id == customerId);
    if (customerId > -1) {
      _customerMessage[customerIndex].firstLoad = false;
    }
  }

  void addPreviousMessage(int customerId, List<Message> messages) {
    var customerIndex = findCustomerIndexById(customerId);
    for (var item in messages) {
      var sameId = customerMessage[customerIndex]
          .message
          .indexWhere((element) => element.id == item.id);
      if (sameId == -1) {
        customerMessage[customerIndex].message.add(item);
      }
    }
  }

  void getPastMessages({required int customerId, bool loadMore = false}) async {
    var customerIndex = findCustomerIndexById(customerId);
    var messages = customerMessage[customerIndex].message;
    if (customerMessage[customerIndex].allLoaded) {
      return;
    }
    if (messages.isNotEmpty) {
      chatLoading = true;
      var lastMessageId = messages.last.id;
      var response = await _messageService.getPastMessages(
          customerId: customerId,
          loadMore: loadMore,
          lastMessageId: lastMessageId,
          token: _token);

      if (response.isNotEmpty) {
        addPreviousMessage(customerId, response);
      } else {
        customerMessage[customerIndex].allLoaded = true;
      }
      chatLoading = false;
      notifyListeners();
    }
  }

  int findCustomerIndexById(int customerId) {
    return _customerMessage
        .indexWhere((element) => element.customer.id == customerId);
  }

  void sendMessage({required String customerNumber, required String message}) {
    _messageService.sendMessage(
        customerNumber: customerNumber, message: message, token: _token);
  }

  void sendDocument({required File file, required String customerNumber}) {
    _messageService.sendDocument(
        file: file, customerNumber: customerNumber, token: _token);
  }

  Future<ApiResponse<List<Message>?>> sendImage(
      {required XFile file,
      required String customerNumber,
      required String message,
      required String type}) async {
    if (type == "video") {
      return await _messageService.sendVideo(
          file: file,
          message: message,
          customerNumber: customerNumber,
          token: _token);
    } else {
      return await _messageService.sendImage(
          file: file,
          message: message,
          customerNumber: customerNumber,
          token: _token);
    }
  }

  Future<ApiResponse<StartConversationResponse?>> startConversation(
      int customerId) async {
    var response = await _messageService.startConversation(customerId, _token);
    if (response.success && response.data != null) {
      _customerMessage.add(CustomerMessage(
          customer: response.data!.data!.customer!,
          agents: [response.data!.data!.agent!],
          message: [],
          unread: 0));
    }
    notifyListeners();
    return response;
  }

  List<CustomerCategories> categories = [];
  List<CustomerInterests> interests = [];
  List<CustomerTypes> types = [];

  void getCategoriesTypesInterests() async {
    var customerCategories =
        await _broadcastMessageService.getCustomerCategories(_token);

    if (customerCategories.success && customerCategories.data != null) {
      categories = customerCategories.data!;
    }

    var customerInterests =
        await _broadcastMessageService.getCustomerInterests(_token);

    if (customerInterests.success && customerInterests.data != null) {
      interests = customerInterests.data!;
    }

    var customerTypes = await _broadcastMessageService.getCustomerTypes(_token);

    if (customerTypes.success && customerTypes.data != null) {
      types = customerTypes.data!;
    }
  }

  final List<MessageTemplate> _templates = [];
  List<MessageTemplate> get templates => List.unmodifiable(_templates);

  Future<ApiResponse<List<MessageTemplate>>> getTemplates(
      BuildContext context) async {
    var response = await _messageTemplateService.getTemplates(_token);

    if (response.success && response.data != null) {
      _templates.clear();
      _templates.addAll(response.data!);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));
    }
    notifyListeners();
    return response;
  }

  Future<ApiResponse<List<Message>?>> sendBroadcastMessage(
      List<CustomerCategories> categories,
      List<CustomerInterests> interests,
      List<CustomerTypes> types,
      String message) async {
    var response = await _broadcastMessageService.sendBroadcastMessage(
        categories: categories.map((e) => e.name ?? "").toList(),
        types: types.map((e) => e.name ?? "").toList(),
        interests: interests.map((e) => e.name ?? "").toList(),
        message: message,
        token: _token);
    notifyListeners();
    return response;
  }

  Future<ApiResponse<MessageTemplate?>> saveTemplate(
      int? id, String name, String template) async {
    late ApiResponse<MessageTemplate?> response;
    if (id != null) {
      response = await _messageTemplateService.editTemplate(
          id, name, template, _token);
    } else {
      response =
          await _messageTemplateService.addTemplate(name, template, _token);
    }

    if (response.success) {
      var templatesIndex =
          _templates.indexWhere((element) => element.id == response.data!.id);
      if (templatesIndex > -1) {
        _templates[templatesIndex] = response.data!;
      } else {
        _templates.add(response.data!);
      }
    }

    notifyListeners();

    return response;
  }

  Future<ApiResponse<MessageTemplate?>> deleteTemplate(int id) async {
    ApiResponse<MessageTemplate?> response =
        await _messageTemplateService.deleteTemplate(id, _token);

    if (response.success) {
      var templatesIndex =
          _templates.indexWhere((element) => element.id == response.data!.id);
      if (templatesIndex > -1) {
        _templates.removeAt(templatesIndex);
      }
    }

    notifyListeners();

    return response;
  }
}
