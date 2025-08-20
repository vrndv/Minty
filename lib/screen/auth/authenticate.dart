import 'package:flutter/material.dart';
import 'package:popapp/screen/auth/login.dart';
import 'package:popapp/screen/auth/register.dart';

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
        title: const Text(' PopApp', style: TextStyle(fontSize: 24,color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(40, 175, 173, 173),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               const SizedBox(height: 50),
             Icon(Icons.api_sharp, size: 100, color: const Color.fromARGB(104, 0, 0, 0)),
              const Text('Welcome to PopApp', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 150),
              Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Login(icon: Icons.login, barTitle: "Login", subText: "Don't have an account?");
                        },));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(5)),
                        child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                      ),
                    ),
                  ),
              Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Register(icon: Icons.app_registration, barTitle: "Register", subText: "Already a member?");
                        },));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(5)),
                        child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }


}
