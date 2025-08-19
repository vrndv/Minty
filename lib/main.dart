import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:popapp/database.dart';
import 'firebase_options.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});




  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  TextEditingController textController = TextEditingController();
  int id = 0;
  String? text;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PopApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PopApp Home'),
        ),
        body: Center(
          
          child: Column(
            children: [
              Text('Welcome to PopApp!'),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Enter some text',
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                 DatabaseService().writeData("data1", {"name": textController.text, "id": id });
                  id++;
                },
                child: const Text('Press Me'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final data = await DatabaseService().readData("data1");
                  setState(() {
                    text ="Name : ${data.child('name').value.toString()} \n ID : ${ data.child('id').value.toString()}";
                  });
                },
                child: const Text('Read Data'),
              ),
              Text(text ?? ''),
            ],
          ) 
        ),
      ),
    );
  }
}

