import 'package:aloha/data/response/Message.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert';
import '../response/Contact.dart';
import 'package:http/http.dart';

class MessageService extends ChangeNotifier {
  Map<int, CustomerMessage> customerMessage = {};

  MessageService() {
    setupSocket();
  }

  setupSocket() {
    try {
      var socketClient = io(
        "https://dev.mirfanrafif.me/messages",
        OptionBuilder().setTransports(['websocket']).build(),
      );
      var data = {'id': 3};
      socketClient.emit("join", jsonEncode(data));

      socketClient.on("message", (data) {
        var incomingMessage = Message.fromJson(jsonDecode(data as String));
        if (customerMessage[incomingMessage.customer.id] == null) {
          CustomerMessage(
              customer: incomingMessage.customer, message: [incomingMessage]);
        }
        customerMessage[incomingMessage.customer.id]
            ?.message
            .add(incomingMessage);
        notifyListeners();
        return data;
      });
    } catch (e) {
      print(e);
    }
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

    var newListMessage = [
      ...customerMessage[customerId]?.message ?? [],
      ...messages,
    ];

    customerMessage[customerId]?.message = newListMessage;
    notifyListeners();
  }

  Future<List<Message>> getPastMessages(
      {required int customerId, bool loadMore = false}) async {
    print(customerMessage[customerId]?.message.last.id.toString());
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
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNjQ4NjQxNDU3LCJleHAiOjE2NDg3Mjc4NTd9.hBNS-iSlih0p5RHDyIQ1KAje4O2IMqgATTvJkAiRL2o'
        });
    print(response.body);
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

  CustomerMessage({required this.customer, required this.message});
}
