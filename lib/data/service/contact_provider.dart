import 'package:aloha/data/response/Contact.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../response/Message.dart';

class ContactProvider extends ChangeNotifier {
  final List<CustomerMessage> _customerMessage = [];

  List<CustomerMessage> get customerMessage =>
      List.unmodifiable(_customerMessage);

  ContactProvider() {
    getAllContact();
    setupSocket();
  }

  var loading = false;

  List<Message> getMessageByCustomerId(int customerId) =>
      _customerMessage[findCustomerIndexById(customerId)].message;

  Future<List<Contact>> getAllContact() async {
    try {
      var response =
          await get(Uri.https("dev.mirfanrafif.me", "/message"), headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNjQ4NzI4MDk5LCJleHAiOjE2NDg4MTQ0OTl9.l5_JOlx3pExOsN7i5gaPTfKX0uLziO8qu91AdyEg6Ew'
      });
      if (response.statusCode == 200) {
        var data = ContactResponse.fromJson(jsonDecode(response.body));
        mapContactToCustomerMessage(data.data);
        return data.data;
      } else {
        print(response.body);
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  void mapContactToCustomerMessage(List<Contact> contactList) {
    for (var contact in contactList) {
      _customerMessage.add(CustomerMessage(
          customer: contact.customer, message: [contact.lastMessage]));
    }
    notifyListeners();
  }

  void setupSocket() {
    var socketClient =
        io("https://dev.mirfanrafif.me/messages", <String, dynamic>{
      'transports': ['websocket'],
      "autoConnect": false,
    });

    socketClient.connect();

    socketClient.onConnectError((data) {
      print("Error : " + data);
    });
    socketClient.onConnect((data) {
      print("Connected");

      var data = {'id': 3};
      socketClient.emit("join", jsonEncode(data));

      socketClient.on("message", (data) {
        print(data);
        var incomingMessage = Message.fromJson(jsonDecode(data as String));
        // if (customerMessage[incomingMessage.customer.id] == null) {
        //   CustomerMessage(
        //       customer: incomingMessage.customer, message: [incomingMessage]);
        // }
        // var messageIndex = customerMessage[incomingMessage.customer.id]
        //     ?.message
        //     .indexWhere((element) => element.id == incomingMessage.id);
        // if (messageIndex != null && messageIndex == -1) {
        //   customerMessage[incomingMessage.customer.id]?.message = [
        //     incomingMessage,
        //     ...customerMessage[incomingMessage.customer.id]?.message ??
        //         <Message>[]
        //   ];
        // }
        notifyListeners();
        return data;
      });
    });
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
    for (var item in messages) {
      var sameId = customerMessage[customerId]
          .message
          .indexWhere((element) => element.id == item.id);
      if (sameId == -1) {
        customerMessage[customerId].message.add(item);
      }
    }
    notifyListeners();
  }

  int findCustomerIndexById(int customerId) {
    return _customerMessage
        .indexWhere((element) => element.customer.id == customerId);
  }

  Future<List<Message>> getPastMessages(
      {required int customerId, bool loadMore = false}) async {
    var customerIndex = findCustomerIndexById(customerId);
    var response = await get(
        Uri.https(
            "dev.mirfanrafif.me",
            "/message/${customerId.toString()}",
            loadMore
                ? {
                    'last_message_id': _customerMessage[customerIndex]
                        .message
                        .last
                        .id
                        .toString()
                  }
                : {}),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNjQ4NzI4MDk5LCJleHAiOjE2NDg4MTQ0OTl9.l5_JOlx3pExOsN7i5gaPTfKX0uLziO8qu91AdyEg6Ew'
        });
    if (response.statusCode == 200) {
      var data = messageResponseFromJson(response.body);
      addPreviousMessage(customerIndex, data.data);
      return data.data;
    } else {
      return [];
    }
  }
}

class CustomerMessage {
  Customer customer;

  List<Message> message;

  bool firstLoad = true;

  CustomerMessage({required this.customer, required this.message});
}
