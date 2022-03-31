import 'package:aloha/data/response/Message.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert';
import '../response/Contact.dart';
import 'package:http/http.dart';

class MessageProvider extends ChangeNotifier {
  Map<int, CustomerMessage> customerMessage = {};

  MessageProvider() {
    setupSocket();
  }

  mapContactToCustomerMessage(List<Contact> contactList) {
    contactList.forEach((element) {
      customerMessage[element.customer.id] = CustomerMessage(
          customer: element.customer, message: [element.lastMessage]);
    });
  }

  setupSocket() {
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
        if (customerMessage[incomingMessage.customer.id] == null) {
          CustomerMessage(
              customer: incomingMessage.customer, message: [incomingMessage]);
        }
        var messageIndex = customerMessage[incomingMessage.customer.id]
            ?.message
            .indexWhere((element) => element.id == incomingMessage.id);
        if (messageIndex != null && messageIndex == -1) {
          customerMessage[incomingMessage.customer.id]?.message = [
            incomingMessage,
            ...customerMessage[incomingMessage.customer.id]?.message ??
                <Message>[]
          ];
        }
        notifyListeners();
        return data;
      });
    });
  }

  setFirstLoadDone(int customerId) {
    customerMessage[customerId]?.firstLoad = false;
  }

  addPreviousMessage(int customerId, List<Message> messages) {
    for (var item in messages) {
      var sameId = customerMessage[customerId]
          ?.message
          .indexWhere((element) => element.id == item.id);
      if (sameId != null && sameId == -1) {
        customerMessage[customerId]!.message.add(item);
      }
    }
    notifyListeners();
  }

  Future<List<Message>> getPastMessages(
      {required int customerId, bool loadMore = false}) async {
    var response = await get(
        Uri.https(
            "dev.mirfanrafif.me",
            "/message/${customerId.toString()}",
            loadMore
                ? {
                    'last_message_id':
                        customerMessage[customerId]!.message.last.id.toString()
                  }
                : {}),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNjQ4NzI4MDk5LCJleHAiOjE2NDg4MTQ0OTl9.l5_JOlx3pExOsN7i5gaPTfKX0uLziO8qu91AdyEg6Ew'
        });
    if (response.statusCode == 200) {
      var data = messageResponseFromJson(response.body);
      addPreviousMessage(customerId, data.data);
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
