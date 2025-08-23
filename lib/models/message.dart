import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {

  final String SenderUname;
  final String message;
  final Timestamp time;

  Messages({
    required this.SenderUname,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'SenderUid': SenderUname,
      'message': message,
      'time': time,
    };
  }
}
