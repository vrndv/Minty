import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:popapp/screen/auth/authenticate.dart';
import 'package:popapp/screen/home/navbar.dart';
import 'package:popapp/screen/views/tree.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
class DataBaseForm extends StatefulWidget {
  final String userEmail;
  const DataBaseForm({super.key, required this.userEmail});

  @override
  State<DataBaseForm> createState() => _DataBaseFormState();
}

class _DataBaseFormState extends State<DataBaseForm> {
  TextEditingController textController = TextEditingController();
  int id = 0;
  String? text;
  String? out;
  String err = " ";
  @override
  @override
  void initState() {
    super.initState();
    currentUser.value = widget.userEmail; 
    if (currentUser.value == "null") {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Auth();
      },));}
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopApp Home'),
        elevation: 20,
        shadowColor: const Color.fromARGB(83, 0, 0, 0),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              widget.userEmail,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
      body: WidgetTree(),
      
      bottomNavigationBar: Navbar(),
    );
  }
}
