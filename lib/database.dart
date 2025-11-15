import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';

class DatabaseService {
  final db = FirebaseFirestore.instance;

  // Create a new user wit
  Future<bool> userExist({required String data}) async {
    var check = await db
        .collection("user")
        .where("username", isEqualTo: data)
        .get();

    return check.docs.isNotEmpty;
  }

  Future<void> write({required Map<String, dynamic> data}) async {
    print(data);
    try {
      await db.collection("user").add(data).then((DocumentReference doc) {});
    } catch (e) {
      print(e);
    }
  }

  Future<String> read() async {
    String? out;
    var event = await db.collection("user").get();

    if (true) {
      for (var doc in event.docs) {
        out = "$out ${("${doc.id} => ${doc.data()} \n")}";
      }
    }
    return out ?? "";
  }

  Future<bool> usernameExist({required String email}) async {
    var check = await db
        .collection("user")
        .where("email", isEqualTo: email)
        .get();
    return check.docs.isNotEmpty;
  }

  Future isPhone({required String username, required String roomID}) async {
    final check = await db.collection("chats").doc(roomID.toString()).get();
    if (!(check.exists)) {
      final snapshot = await db
          .collection("user")
          .where("username", isEqualTo: username)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        bool isPhone = data["isPhone"] ?? false;
        // return (isPhone);
        if (isPhone) {
          final snapshot = await db
              .collection("numphone")
              .where("username", isEqualTo: username)
              .limit(1)
              .get();
          if (snapshot.docs.isNotEmpty) {
            final data = snapshot.docs.first.data();
            final index = data["index"] + 1;
            final phone = data["phone"] as String;
            await db
                .collection("numphone")
                .doc(phone.toString())
                .collection("roomid")
                .doc(index.toString())
                .set({"roomid": roomID, "with": currentUser.value});
            await db.collection("numphone").doc(phone.toString()).update({
              "index": index,
            });
          }
        }
      } else {
        return null;
      }
    }
  }

  Future<bool> checkPhoneUser({required String username}) async {
    final snapshot = await db
        .collection("numphone")
        .where("username", isEqualTo: username)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<String> findUsername({required String email}) async {
    var check = await db
        .collection("user")
        .where("email", isEqualTo: email)
        .get();
    return check.docs.first["username"];
  }

  Future<void> pushAvatar({required String id, required String seed}) async {
    var data = await db
        .collection("user")
        .where("uid", isEqualTo: id)
        .limit(1)
        .get();
    var docid = data.docs.first.id;
    await db.collection("user").doc(docid).update({"pfp": seed});
  }
}
