import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/models/message.dart';
import 'package:popapp/screen/views/pages/chat.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String message,
    required String roomID,
    required String senderUid,
    required String receiverUid,
    required String senderUsername,
    required String receiverUsername,
  }) async {
    final String username = currentUser.value; // sender username
    final Timestamp time = Timestamp.now();

    // Message object
    Messages newMessage = Messages(
      senderUname: username,
      message: message,
      time: time,
      receiverUsername :receiverUsername,
    );

    final DocumentReference chatDocRef = _firestore
        .collection("chats")
        .doc(roomID);

    // Step 1: Ensure chat document exists and has participants
    await chatDocRef.set({
      "participants": [senderUid, receiverUid],
      "usernames" : {senderUid : senderUsername , receiverUid : receiverUsername},
      "lastMsg" : message,
      "lastUpdated": time,
    }, SetOptions(merge: true)); 
    await chatDocRef.collection("messages").add(newMessage.toMap());
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

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsers() {
    return _firestore.collection("chats")
        .where("participants", arrayContains: userID.value)
        .orderBy("lastUpdated", descending: true)
        .snapshots();
  }
}

ChatPage userChatPage({
  required String u1,
  required String u2,
  required String senderUsername,
  required String receiverUsername,
}) {
  if (u1 == "global") {
    return ChatPage(
      roomID: "global",
      senderUid: u2,
      receiverUid: "global",
      senderUsername: senderUsername,
      receiverUsername: "global",
    );
  } else {
    final List<String> ids = [u1, u2];
    ids.sort();
    final roomID = ids.join("_");
    return ChatPage(
      roomID: roomID,
      senderUid: u2,
      receiverUid: u1,
      senderUsername: senderUsername,
      receiverUsername: receiverUsername,
    );
  }
}
