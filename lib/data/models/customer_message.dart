import '../response/contact.dart';
import '../response/message.dart';

class CustomerMessage {
  Customer customer;

  List<Message> message;

  List<User> agents;

  bool firstLoad = true;

  bool allLoaded = false;

  int unread = 0;

  CustomerMessage(
      {required this.customer,
      required this.agents,
      required this.message,
      required this.unread});
}
