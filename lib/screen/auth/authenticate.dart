import 'package:flutter/material.dart';
import 'package:popapp/screen/auth/login.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Authentication Screen'),
            ElevatedButton(
              onPressed: () {
                // Add authentication logic here
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginorReg(icon: Icons.login, barTitle: "Login");
                },));
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add registration logic here
                 Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginorReg(icon: Icons.app_registration, barTitle: "Register");
                },));
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}