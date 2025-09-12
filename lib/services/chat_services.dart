import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/models/message.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<void> sendMessage({required String message , required String roomID}) async {
    final String username = currentUser.value;
    final Timestamp time = Timestamp.now();

    Messages newMessage = Messages(
      SenderUname: username,
      message: message,
      time: time,
    );
    await _firestore
        .collection("chats")
        .doc(roomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage({required String roomID}) {
    return _firestore
        .collection("chats")
        .doc(roomID)
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots();
  }
}

class UserServices{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsers() {
    return _firestore
        .collection("user")
        .snapshots();
  }
}
