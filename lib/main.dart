import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:popapp/database.dart';
import 'package:popapp/screen/auth/authenticate.dart';
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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PopApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Auth(),
    );
  }
}




//Home page for now





class DataBaseForm extends StatefulWidget {
  const DataBaseForm({super.key});

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
      );
  }
}

