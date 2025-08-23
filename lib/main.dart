import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:popapp/database.dart';
import 'package:popapp/screen/auth/authenticate.dart';
import 'package:popapp/screen/home/home.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart';

//Just to save point ,the username adding option is currently situated in homescreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await RiveFile.initialize();
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            // Use FutureBuilder to handle async username lookup
            return FutureBuilder<String>(
              future: DatabaseService().findUsername(
                email: snapshot.data!.email!,
              ),
              builder: (context, unameSnapshot) {
                if (unameSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (unameSnapshot.hasError) {
                  return Auth();
                }
                if (unameSnapshot.hasData) {
                  return DataBaseForm(userEmail: unameSnapshot.data!);
                }
                return const Scaffold(
                  body: Center(child: Text('No username found')),
                );
              },
            );
          }
          // User is not signed in
          return const Auth();
        },
      ),
    );
  }
}
