import 'dart:io';

import 'package:aloha/data/response/Contact.dart';
import 'package:aloha/data/service/message_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart';

import '../models/customer_message.dart';
import '../response/Message.dart';

class MessageProvider extends ChangeNotifier {
  List<CustomerMessage> _customerMessage = [];

  final MessageService _messageService = MessageService();

  List<CustomerMessage> get customerMessage =>
      List.unmodifiable(_customerMessage);

  String token = "";

  void setToken(String token) {
    this.token = token;
  }

  init() {
    getAllContact(token);
    setupSocket();
  }

  var loading = false;

  List<Message> getMessageByCustomerId(int customerId) =>
      _customerMessage[findCustomerIndexById(customerId)].message;

  void getAllContact(String token) async {
    _messageService.getAllContact(token).then((value) {
      mapContactToCustomerMessage(value);
    });
  }

  void mapContactToCustomerMessage(List<Contact> contactList) {
    for (var contact in contactList) {
      _customerMessage.add(CustomerMessage(
          customer: contact.customer,
          message: contact.lastMessage != null ? [contact.lastMessage!] : []));
    }
    notifyListeners();
  }

  void setupSocket() {
    try {
      var socketClient = io("https://dev.mirfanrafif.me/messages",
          OptionBuilder().setTransports(['websocket']).build());

      socketClient.onConnectError((data) {
        if (data is WebSocketException) {
          print("Error : " + data.message);
        } else {
          print("Error : " + data);
        }
      });
      socketClient.onConnect((data) {
        print("Connected");

        var data = {'id': 3};
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
    notifyListeners();
  }

  void getPastMessages(
      {required int customerId, bool loadMore = false, required String token}) {
    var messages = customerMessage[findCustomerIndexById(customerId)].message;
    if (messages.isNotEmpty) {
      var lastMessageId = messages.last.id;
      _messageService
          .getPastMessages(
              customerId: customerId,
              loadMore: loadMore,
              lastMessageId: lastMessageId,
              token: token)
          .then((value) {
        addPreviousMessage(customerId, value);
      });
    }
  }

  int findCustomerIndexById(int customerId) {
    return _customerMessage
        .indexWhere((element) => element.customer.id == customerId);
  }

  void sendMessage({required String customerNumber, required String message}) {
    _messageService.sendMessage(
        customerNumber: customerNumber, message: message, token: token);
  }
}
