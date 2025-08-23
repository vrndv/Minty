import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popapp/screen/auth/login.dart';
import 'package:popapp/screen/auth/updateinfo.dart';

class Register extends StatefulWidget {
  final IconData icon;
  final String barTitle;
  final String subText;
  const Register({
    super.key,
    required this.icon,
    required this.barTitle,
    required this.subText,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? err;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController cpwController = TextEditingController();
  bool pwerrClr = false;
  bool emailerrClr = false;

  Future<void> register() async {
    err = "";
    if (pwController.text != cpwController.text) {
      setState(() {
        err = '$err The passwords does not match \n';
        pwerrClr = true;
      });
    } else {
      setState(() {
        pwerrClr = false;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: pwController.text,
        );
        setState(() {
          emailerrClr = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return UpdateInfo(userEmail: emailController.text);
              },
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'weak-password') {
            err = 'The password provided is too weak.\n';
          }
          if (e.code == 'email-already-in-use') {
            err = '$err The account already exists for that email.\n';
            emailerrClr = true;
          }

          if (e.code == 'invalid-email') {
            err = '$err The email address is not valid.\n';
            emailerrClr = true;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.barTitle)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Icon(widget.icon, size: 50, color: Colors.black54),
              SizedBox(height: 20),
              Text(
                "Let's get you started ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 80),
              Text(
                err ?? "",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("(Beta)")],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: emailerrClr
                            ? const Color.fromARGB(255, 241, 57, 44)
                            : Colors.black45,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: emailerrClr
                            ? const Color.fromARGB(255, 255, 44, 29)
                            : Colors.black,
                        width: pwerrClr ? 1.95 : 1.5,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(55, 0, 0, 0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: pwController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: pwerrClr
                            ? const Color.fromARGB(255, 241, 57, 44)
                            : Colors.black45,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: pwerrClr
                            ? const Color.fromARGB(255, 255, 44, 29)
                            : Colors.black,
                        width: pwerrClr ? 1.95 : 1.5,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(55, 0, 0, 0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: cpwController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: pwerrClr
                            ? const Color.fromARGB(255, 241, 57, 44)
                            : Colors.black45,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: pwerrClr
                            ? Color.fromARGB(255, 255, 44, 29)
                            : Colors.black,
                        width: pwerrClr ? 1.95 : 1.5,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(55, 0, 0, 0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),

              Center(
                child: GestureDetector(
                  onTap: () async {
                    register();
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        widget.barTitle,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.subText),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Login(
                              icon: Icons.login,
                              barTitle: "Login",
                              subText: "Don't have an account?",
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
