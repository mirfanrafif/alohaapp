import 'dart:io';

import 'package:aloha/components/pages/home_page.dart';
import 'package:aloha/data/preferences/user_preferences.dart';
import 'package:aloha/data/response/contact.dart';
import 'package:aloha/data/response/customer_categories.dart';
import 'package:aloha/data/response/message_template.dart';
import 'package:aloha/data/service/broadcast_message_service.dart';
import 'package:aloha/data/service/message_service.dart';
import 'package:aloha/data/service/message_template_service.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  int? _selectedCustomerId;

  bool firstLoad = false;

  int? get selectedCustomerId => _selectedCustomerId;

  set selectedCustomerId(int? newValue) {
    _selectedCustomerId = newValue;
    notifyListeners();
  }

  CustomerMessage getSelectedCustomer() {
    var customerIndex = findCustomerIndexById(_selectedCustomerId ?? 0);
    return customerMessage[customerIndex];
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var contactLoading = false;

  Future<void> init(BuildContext context) async {
    firstLoad = true;
    _token = _preferences.getToken();
    var user = _preferences.getUser();
    _id = user.id;
    setupSocket(context);
    getTemplates(context);
    contactLoading = true;
    var response = await getAllContact();
    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(response.message)));
    }

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: ((id, title, body, payload) {
      onDidReceiveLocalNotification(context, id, title, body, payload);
    }));

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        macOS: initializationSettingsMacOS,
        iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (something) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomePage(),
      ));
    });

    contactLoading = false;
    notifyListeners();
  }

  void onDidReceiveLocalNotification(BuildContext context, int id,
      String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(body ?? ""),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
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

  List<MessageEntity> getMessageByCustomerId(int customerId) =>
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
      if (_customerMessage.indexWhere(
              (element) => element.customer.id == contact.customer.id) ==
          -1) {
        _customerMessage.add(CustomerMessage(
          agents: contact.agent,
          customer: contact.customer,
          message: contact.lastMessage != null ? [contact.lastMessage!] : [],
          unread: contact.unread,
        ));
      }
    }
    sorting();
    notifyListeners();
  }

  sorting() {
    List<CustomerMessage> customerMessageWithEmptyChat = [..._customerMessage];
    customerMessageWithEmptyChat
        .removeWhere((element) => element.message.isNotEmpty);

    List<CustomerMessage> customerMessageWithUnreadMessages = [
      ..._customerMessage
    ]
      ..removeWhere((element) => element.unread == 0)
      ..removeWhere((element) => element.message.isEmpty)
      ..sort((a, b) => b.message.first.createdAt!.millisecondsSinceEpoch
          .compareTo(a.message.first.createdAt!.millisecondsSinceEpoch));

    List<CustomerMessage> customerMessageNoUnreadMessages = [
      ..._customerMessage
    ]
      ..removeWhere((element) => element.message.isEmpty)
      ..removeWhere((element) => element.unread > 0)
      ..sort((a, b) => b.message.first.createdAt!.millisecondsSinceEpoch
          .compareTo(a.message.first.createdAt!.millisecondsSinceEpoch));

    List<CustomerMessage> result = [];
    result.addAll(customerMessageWithUnreadMessages);
    result.addAll(customerMessageNoUnreadMessages);
    result.addAll(customerMessageWithEmptyChat);

    _customerMessage = result;
  }

  void logout() {
    _customerMessage.clear();
    _preferences.logout();
    socketClient.disconnect();
    notifyListeners();
  }

  void setupSocket(BuildContext context) {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating, content: Text(e.toString())));
    }
  }

  processIncomingMessage(String data) {
    var incomingMessage = MessageEntity.fromJson(jsonDecode(data));
    var customerIndex = findCustomerIndexById(incomingMessage.customer.id);
    if (customerIndex == -1) {
      _customerMessage = [
        CustomerMessage(
            agents: [],
            customer: incomingMessage.customer,
            message: [incomingMessage],
            unread: incomingMessage.fromMe ? 0 : 1),
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

          //kirim notifikasi jika ada chat dari customer
          const AndroidNotificationDetails androidPlatformChannelSpecifics =
              AndroidNotificationDetails('MESSAGE', 'Message',
                  channelDescription: 'Pesan masuk dari customer',
                  importance: Importance.max,
                  priority: Priority.high,
                  ticker: 'ticker');
          const NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          flutterLocalNotificationsPlugin.show(
              incomingMessage.customer.id,
              incomingMessage.senderName,
              incomingMessage.message,
              platformChannelSpecifics,
              payload: 'item x');
        }
      } else {
        //bagian ini cuma buat update tracking
        customerMessage[customerIndex].message[messageIndex].status =
            incomingMessage.status;
      }
    }
    sorting();

    notifyListeners();
    return data;
  }

  void sendNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  bool getIsFirstLoad() {
    var customerIndex = findCustomerIndexById(_selectedCustomerId ?? 0);
    return _customerMessage[customerIndex].firstLoad;
  }

  void setFirstLoadDone() {
    var customerIndex = findCustomerIndexById(_selectedCustomerId ?? 0);
    if (customerIndex > -1) {
      _customerMessage[customerIndex].firstLoad = false;
    }
  }

  void addPreviousMessage(List<MessageEntity> messages) {
    var customerIndex = findCustomerIndexById(_selectedCustomerId ?? 0);
    for (var item in messages) {
      var sameId = customerMessage[customerIndex]
          .message
          .indexWhere((element) => element.id == item.id);
      if (sameId == -1) {
        customerMessage[customerIndex].message.add(item);
      }
    }
  }

  void getPastMessages({bool loadMore = false}) async {
    var customerIndex = findCustomerIndexById(_selectedCustomerId ?? 0);
    var messages = customerMessage[customerIndex].message;
    if (customerMessage[customerIndex].allLoaded) {
      return;
    }
    if (messages.isNotEmpty) {
      chatLoading = true;
      var lastMessageId = messages.last.id;
      var response = await _messageService.getPastMessages(
          customerId: _selectedCustomerId ?? 0,
          loadMore: loadMore,
          lastMessageId: lastMessageId,
          token: _token);

      if (response.isNotEmpty) {
        addPreviousMessage(response);
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

  Future<void> sendMessage(
      {required String customerNumber, required String message}) async {
    var response = await _messageService.sendMessage(
        customerNumber: customerNumber, message: message, token: _token);

    if (response.isNotEmpty) {
      var currentIndex = findCustomerIndexById(response.first.customer.id);
      var messageIndex = customerMessage[currentIndex]
          .message
          .indexWhere((element) => element.id == response.first.id);
      if (messageIndex == -1) {
        _customerMessage[currentIndex].message = [
          response.first,
          ..._customerMessage[currentIndex].message
        ];
      }
    }
    notifyListeners();
  }

  Future<ApiResponse<List<MessageEntity>>> sendDocument(
      {required File file, required String customerNumber}) async {
    return await _messageService.sendDocument(
        file: file, customerNumber: customerNumber, token: _token);
  }

  Future<ApiResponse<List<MessageEntity>?>> sendImage(
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

  Future<ApiResponse<CustomerMessage?>> startConversation(
      int customerId) async {
    var response = await _messageService.startConversation(customerId, _token);

    if (response.success && response.data != null) {
      var newContact = CustomerMessage(
          customer: response.data!.data!.customer!,
          agents: [response.data!.data!.agent!],
          message: [],
          unread: 0);
      _customerMessage.add(newContact);
      return ApiResponse(
          success: true, data: newContact, message: response.message);
    }
    notifyListeners();
    return ApiResponse(success: false, data: null, message: response.message);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(response.message)));
    }
    notifyListeners();
    return response;
  }

  Future<void> sendBroadcastMessage(
      List<CustomerCategories> categories,
      List<CustomerInterests> interests,
      List<CustomerTypes> types,
      String message,
      String broadcastType,
      File? file,
      BuildContext context) async {
    var categoriesList = categories.map((e) => e.name ?? "").toList();
    var typesList = types.map((e) => e.name ?? "").toList();
    var interestList = interests.map((e) => e.name ?? "").toList();
    late ApiResponse<List<MessageEntity>?> response;
    switch (broadcastType) {
      case "text":
        response = await _broadcastMessageService.sendBroadcastMessage(
            categories: categoriesList,
            types: typesList,
            interests: interestList,
            message: message,
            token: _token);
        break;
      case "image":
        response = await _broadcastMessageService.sendImage(
            categories: categoriesList,
            types: typesList,
            interests: interestList,
            message: message,
            file: file!,
            token: _token);
        break;
      case "document":
        response = await _broadcastMessageService.sendDocument(
            categories: categoriesList,
            types: typesList,
            interests: interestList,
            file: file!,
            token: _token);
        break;
      case "video":
        response = await _broadcastMessageService.sendVideo(
            categories: categoriesList,
            types: typesList,
            interests: interestList,
            file: file!,
            message: message,
            token: _token);
        break;
    }
    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(response.message)));
    } else {
      Navigator.pop(context);
    }
    notifyListeners();
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

  Future<void> assignCustomerToSales(int salesId, BuildContext context) async {
    var response = await _messageService.assignCustomerToSales(
        getSelectedCustomer().customer.id, salesId, _token);

    if (response.success) {
      var customerIndex =
          findCustomerIndexById(getSelectedCustomer().customer.id);
      customerMessage[customerIndex].agents.add(response.data!.data!.agent!);
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(response.message)));
    notifyListeners();
  }

  Future<void> unassignCustomerToSales(
      int salesId, BuildContext context) async {
    var response = await _messageService.unassignCustomerToSales(
        getSelectedCustomer().customer.id, salesId, _token);

    if (response.success) {
      var customerIndex =
          findCustomerIndexById(getSelectedCustomer().customer.id);
      customerMessage[customerIndex].agents.removeWhere(
          (element) => element.id == response.data!.data!.agent!.id);
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(response.message)));
    notifyListeners();
  }
}
