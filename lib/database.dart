import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final db = FirebaseFirestore.instance;

  // Create a new user wit
  Future<bool> userExist({required String data}) async {
    var check =await db.collection("user").where("username",isEqualTo: data).get();

    return check.docs.isEmpty;
  }

  Future<bool> write({required Map<String, dynamic> data}) async {
    if (await userExist(data: data["username"]) == true) {
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

    Future<bool> usernameExist({required String email}) async {
    var check =await db.collection("user").where("email",isEqualTo: email).get();
    return check.docs.isNotEmpty;
  }

  Future<String> findUsername({required String email}) async {
    var check =await db.collection("user").where("email",isEqualTo: email).get();
    return check.docs.first["username"];
  }


    
}



