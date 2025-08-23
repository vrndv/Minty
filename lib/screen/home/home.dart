
import 'package:flutter/material.dart';


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
  bool isValidUsername(String username) {
    final validUsernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return validUsernameRegex.hasMatch(username);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopApp Home'),
        actions: [
          Text(
            widget.userEmail,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ],
      ),
      body: null,
    );
  }
}
