import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {

  final String senderUname;
  final String receiverUsername;
  final String message;
  final Timestamp time;
  final bool isPhone;
  Messages({
    required this.senderUname,
    required this.receiverUsername,
    required this.message,
    required this.time,
    required this.isPhone

  });

  Map<String, dynamic> toMap() {
    return {
      'username': senderUname,
      "reciever":receiverUsername,
      'message': message,
      'time': time,
      'isPhone':isPhone,
    };
  }
}
