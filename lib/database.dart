
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference get reference => _database.ref();

  Future<void> writeData(String path, Map<String, dynamic> data) async {
    print("going to connect to database");
    await reference.child(path).set(data);
    print("data written to database at path: $path");
  }

  Future<DataSnapshot> readData(String path) async {
    return await reference.child(path).get();
    }

  Future<void> updateData(String path, Map<String, dynamic> data) async {
    await reference.child(path).update(data);
  }

  Future<void> deleteData(String path) async {
    await reference.child(path).remove();
  }
}