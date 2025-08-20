import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:popapp/database.dart';
import 'package:popapp/screen/auth/authenticate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PopApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Auth(),
    );
  }
}

//Home page for now

class DataBaseForm extends StatefulWidget {
  final String user;
  const DataBaseForm({super.key, required this.user});

  @override
  State<DataBaseForm> createState() => _DataBaseFormState();
}

class _DataBaseFormState extends State<DataBaseForm> {
  TextEditingController textController = TextEditingController();
  int id = 0;
  String? text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopApp Home'),
        actions: [
          Text(
            widget.user,
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return Auth();
                  },));
                },
                child: Icon(Icons.logout),
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Enter some text',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseService().writeData("data1", {
                  "name": textController.text,
                  "id": id,
                });
                id++;
              },
              child: const Text('Press Me'),
            ),
            ElevatedButton(
              onPressed: () async {
                final data = await DatabaseService().readData("data1");
                setState(() {
                  text =
                      "Name : ${data.child('name').value.toString()} \n ID : ${data.child('id').value.toString()}";
                });
              },
              child: const Text('Read Data'),
            ),
            Text(text ?? ''),
          ],
        ),
      ),
    );
  }
}
