import '../response/contact.dart';
import '../response/Message.dart';

class CustomerMessage {
  Customer customer;

  List<Message> message;

  bool firstLoad = true;

  bool allLoaded = false;

  int unread = 0;

  CustomerMessage(
      {required this.customer, required this.message, required this.unread});
}
