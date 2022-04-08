import 'dart:io';

import 'package:aloha/data/preferences/user_preferences.dart';
import 'package:aloha/data/response/Contact.dart';
import 'package:aloha/data/service/message_service.dart';
import 'package:aloha/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart';

import '../models/customer_message.dart';
import '../response/Message.dart';

class MessageProvider extends ChangeNotifier {
  List<CustomerMessage> _customerMessage = [];

  final MessageService _messageService = MessageService();
  final UserPreferences _preferences = UserPreferences();

  List<CustomerMessage> get customerMessage =>
      List.unmodifiable(_customerMessage);

  String _token = "";
  int _id = 0;

  void init() {
    _token = _preferences.getToken();
    var user = _preferences.getUser();
    _id = user.id;
    getAllContact();
    setupSocket();
  }

  var chatLoading = false;

  List<Message> getMessageByCustomerId(int customerId) =>
      _customerMessage[findCustomerIndexById(customerId)].message;

  void getAllContact() async {
    var value = await _messageService.getAllContact(_token);
    mapContactToCustomerMessage(value);
  }

  bool getIsAllLoaded(int customerId) {
    var index = findCustomerIndexById(customerId);
    return customerMessage[index].allLoaded;
  }

  void mapContactToCustomerMessage(List<Contact> contactList) {
    for (var contact in contactList) {
      _customerMessage.add(CustomerMessage(
          customer: contact.customer,
          message: contact.lastMessage != null ? [contact.lastMessage!] : []));
    }
    notifyListeners();
  }

  void logout() {
    _customerMessage.clear();
    _preferences.logout();
    notifyListeners();
  }

  void setupSocket() {
    try {
      var socketClient = io(
          "https://" + BASE_URL + "/messages",
          OptionBuilder()
              .setTransports(['websocket'])
              .enableReconnection()
              .build());

      socketClient.onConnectError((data) {
        if (data is WebSocketException) {
          print("Error : " + data.message);
        } else if (data is SocketException) {
          print("Error : " + data.message);
        } else {
          print("Error : " + data);
        }
      });
      socketClient.onConnect((data) {
        print("Connected");

        var data = {'id': _id};
        socketClient.emit("join", jsonEncode(data));

        socketClient.on("message", (data) {
          print(data);
          var incomingMessage = Message.fromJson(jsonDecode(data as String));
          var customerIndex =
              findCustomerIndexById(incomingMessage.customer.id);
          if (customerIndex == -1) {
            _customerMessage = [
              CustomerMessage(
                  customer: incomingMessage.customer,
                  message: [incomingMessage]),
              ..._customerMessage
            ];
          } else {
            var messageIndex = customerMessage[customerIndex]
                .message
                .indexWhere((element) => element.id == incomingMessage.id);
            if (messageIndex == -1) {
              customerMessage[customerIndex].message = [
                incomingMessage,
                ...customerMessage[customerIndex].message
              ];
            } else {
              customerMessage[customerIndex].message[messageIndex] =
                  incomingMessage;
            }
          }

          notifyListeners();
          return data;
        });
      });
    } catch (e) {
      print(e);
    }
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
    chatLoading = true;
    var customerIndex = findCustomerIndexById(customerId);
    var messages = customerMessage[customerIndex].message;
    if (customerMessage[customerIndex].allLoaded) {
      // return;
    } else if (messages.isNotEmpty) {
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
    }

    chatLoading = false;
    notifyListeners();
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

  Future<void> sendImage(
      {required XFile file,
      required String customerNumber,
      required String message}) async {
    await _messageService.sendImage(
        file: file,
        message: message,
        customerNumber: customerNumber,
        token: _token);
  }
}
