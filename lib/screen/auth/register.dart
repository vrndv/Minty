import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/screen/auth/login.dart';
import 'package:SHADE/screen/auth/updateinfo.dart';
import 'package:SHADE/screen/views/widgets/auth_wave.dart';
import 'package:SHADE/screen/views/widgets/login_btn.dart';

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

  void check() {
    setState(() {
      pwerrClr = pwController.text != cpwController.text;
    });
  }

  Future<void> register() async {
    err = "";
    if (pwController.text != cpwController.text) {
      setState(() {
        err = '$err The passwords do not match \n';
        pwerrClr = true;
      });
      return;
    }

    setState(() {
      pwerrClr = false;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: pwController.text,
      );

      emailerrClr = false;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateInfo(userEmail: emailController.text),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'weak-password':
            err = 'The password provided is too weak.\n';
            emailerrClr = false;
            pwerrClr = true;
            break;
          case 'email-already-in-use':
            err = '$err The account already exists for that email.\n';
            emailerrClr = true;
            pwerrClr = false;
            break;
          case 'invalid-email':
            err = '$err The email address is not valid.\n';
            emailerrClr = true;
            pwerrClr = false;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const AuthWave(),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height: 200),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        
                        Container(
                          //color: Colors.amber,
                          width: 160,
                          height: 60,
                          child: Text(
                            " Let's get you",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 15,
                          child: Text(
                            'Started !',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Text(
                      err ?? "",
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),

                    // Email field
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.grey),
                          hint: Text(
                            "myself@abc.com",
                            style: TextStyle(
                              color: currentTheme.value
                                  ? Colors.black26
                                  : Colors.white30,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: emailerrClr
                                  ? const Color.fromARGB(255, 241, 57, 44)
                                  : const Color.fromARGB(82, 255, 254, 254),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: emailerrClr
                                  ? const Color.fromARGB(255, 255, 44, 29)
                                  : const Color.fromARGB(255, 167, 129, 86),
                              width: pwerrClr ? 1.95 : 1.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),

                    // Password field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: pwController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "%abc@123# ",
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: pwerrClr
                                  ? const Color.fromARGB(255, 241, 57, 44)
                                  : const Color.fromARGB(82, 255, 254, 254),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: pwerrClr
                                  ? const Color.fromARGB(255, 255, 44, 29)
                                  : const Color.fromARGB(255, 167, 129, 86),
                              width: pwerrClr ? 1.95 : 1.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        onChanged: (_) => check(),
                        controller: cpwController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          hintText: "%abc@123# ",
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: pwerrClr
                                  ? const Color.fromARGB(255, 241, 57, 44)
                                  : const Color.fromARGB(82, 255, 254, 254),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: pwerrClr
                                  ? const Color.fromARGB(255, 255, 44, 29)
                                  : const Color.fromARGB(255, 167, 129, 86),
                              width: pwerrClr ? 1.95 : 1.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Register button
                    Center(
                      child: GestureDetector(
                        onTap: register,
                        child: const Hero(
                          tag: "reg_btn",
                          child: Login_btn(text: "Register"),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.subText),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Login(
                                  icon: Icons.login,
                                  barTitle: "Login",
                                  subText: "Don't have an account?",
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            " Login",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
