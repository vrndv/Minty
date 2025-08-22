import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final db = FirebaseFirestore.instance;

  // Create a new user wit
  Future<bool> userExist({required Map<String, dynamic> data}) async {
    var check =await db.collection("user").where("username",isEqualTo: data["username"]).get();
    print(check.docs.isNotEmpty);
    return check.docs.isNotEmpty;
  }

  Future<bool> write({required Map<String, dynamic> data}) async {
    if (await userExist(data: data) == false) {
      print(data);
      await db.collection("user").add(data).then((DocumentReference doc) {});
      return false;
    }
    else{
      return true;
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
}
