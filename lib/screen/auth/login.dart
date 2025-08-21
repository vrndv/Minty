import 'package:flutter/material.dart';
import 'package:popapp/screen/auth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:popapp/screen/home/home.dart';

class Login extends StatefulWidget {
  final IconData icon;
  final String barTitle;
  final String subText;
  const Login({
    super.key,
    required this.icon,
    required this.barTitle,
    required this.subText,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  String? err;
  String textF() {
    if (widget.barTitle == "Login")
      return "Register";
    else {
      return "Register";
    }
  }

  login() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    // Handle login logic here
    String email = emailController.text;
    String password = pwController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    
    } on FirebaseAuthException catch (e) {
      setState(() {
        Navigator.pop(context);
        if (e.code == 'user-not-found') {
          err = 'No user found for that email.';
        } else if (e.code == 'invalid-credential') {
          err = 'Wrong password provided for that user.';
        } else {
          err = "An error occurred : ${e.code}";
        }
      });
    }

    if (FirebaseAuth.instance.currentUser != null) {
      // User is logged in, navigate to the home page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DataBaseForm(
              user: FirebaseAuth.instance.currentUser!.email!,
            );
          },
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.barTitle)),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Icon(widget.icon, size: 50, color: Colors.black54),
                SizedBox(height: 20),
                Text(
                  "Welcome back! we missed you!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 80),
                Text(
                  err ?? "",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
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
                    controller: pwController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
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
                    onTap: () {
                      // Handle login logic here
                      login();
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
                              return Register(
                                icon: Icons.app_registration,
                                barTitle: "Register",
                                subText: "Already a member?",
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        (widget.barTitle == "Login") ? "  Register" : "  Login",
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
      ),
    );
  }
}
