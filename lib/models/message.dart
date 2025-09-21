import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {

  final String senderUname;
  final String receiverUsername;
  final String message;
  final Timestamp time;

  Messages({
    required this.senderUname,
    required this.receiverUsername,
    required this.message,
    required this.time,

  });

  Map<String, dynamic> toMap() {
    return {
      'username': senderUname,
      "reciever":receiverUsername,
      'message': message,
      'time': time,
    };
  }
}
