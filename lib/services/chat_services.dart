import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/models/message.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<void> sendMessage({required message}) async {
    final String username = currentUser.value;
    final Timestamp time = Timestamp.now();

    Messages newMessage = Messages(
      SenderUname: username,
      message: message,
      time: time,
    );
    await _firestore
        .collection("chats")
        .doc("global")
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage() {
    return _firestore
        .collection("chats")
        .doc("global")
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots();
  }
}
