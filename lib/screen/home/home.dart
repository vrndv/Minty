import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popapp/database.dart';
import 'package:popapp/screen/auth/authenticate.dart';

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
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Text('Welcome to PopApp!'),
              trailing: GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Auth();
                      },
                    ),
                  );
                },
                child: Icon(Icons.logout),
              ),
            ),
            SizedBox(height: 30),
            Text(err, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Enter some text',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (isValidUsername(textController.text) == true) {
                  setState(() {
                    err = "";
                  });
                  var isWritten = DatabaseService().write(
                    data: {
                      "username": textController.text,
                      "email": widget.userEmail,
                    },
                  );
                  isWritten.then((value) {
                    if (value == true) {
                      setState(() {
                        err = "Username already exists";
                      });
                    } else {
                      setState(() {
                        err = "Data written successfully";
                      });
                    }
                  });
                }
              },
              child: const Text('Press Me'),
            ),
            ElevatedButton(
              onPressed: () async {
                out = await DatabaseService().read();
                setState(() {});
              },
              child: const Text('Read Data'),
            ),
            Text(out ?? ''),
          ],
        ),
      ),
    );
  }
}
