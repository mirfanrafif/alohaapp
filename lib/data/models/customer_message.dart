import '../response/Contact.dart';
import '../response/Message.dart';

class CustomerMessage {
  Customer customer;

  List<Message> message;

  bool firstLoad = true;

  CustomerMessage({required this.customer, required this.message});
}
