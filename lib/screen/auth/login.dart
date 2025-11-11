import 'package:SHADE/screen/views/widgets/auth_wave.dart';
import 'package:SHADE/screen/views/widgets/login_btn.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/database.dart';
import 'package:SHADE/screen/auth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SHADE/screen/auth/updateinfo.dart';
import 'package:SHADE/screen/home/home.dart';

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
    if (widget.barTitle == "Login") {
      return "Register";
    } else {
      return "Register";
    }
  }

  void login() async {
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
      if (await DatabaseService().usernameExist(email: email) == true) {
        var uname = await DatabaseService().findUsername(email: email);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              currentPageNotifier.value = 0;
              currentUser.value = uname;
              try {
                userID.value = FirebaseAuth.instance.currentUser!.uid;
              } catch (e) {
                print("error is : $e");
              }
              
              return DataBaseForm(userEmail: uname, page: 0);
            },
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              currentPageNotifier.value = 0;
              return UpdateInfo(userEmail: email);
            },
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AuthWave(),

            SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 200),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome back! \n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            TextSpan(
                              text: ' we missed you!', 
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),
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
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.grey),
                            
                            hint: Text(
                              "myself@abc.com ",
                              style: TextStyle(
                                color: currentTheme.value
                                    ? Colors.black26
                                    : Colors.white30,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: currentTheme.value
                                    ? Colors.black
                                    : const Color.fromARGB(82, 255, 254, 254),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: currentTheme.value
                                    ? Colors.white
                                    : const Color.fromARGB(255, 167, 129, 86),

                                width: 1.5,
                              ),
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
                            
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.grey),
                            hint: Text(
                              "%abc@123# ",
                              style: TextStyle(
                                color: currentTheme.value
                                    ? Colors.black26
                                    : Colors.white30,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: currentTheme.value
                                    ? Colors.black
                                    : Color.fromARGB(255, 167, 129, 86),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: currentTheme.value
                                    ? Colors.black
                                    : const Color.fromARGB(82, 255, 254, 254),
                                width: 1.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(right: 20, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (emailController.text.contains("@")) {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                        email: emailController.text,
                                      );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Reset link sent to: ${emailController.text}\nChech Spam folders ",
                                      ),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Enter a valid Email ID"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            login();
                          },
                          child: Hero(
                            tag: "login_btn",
                            child: Login_btn(text: "Login"),
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
                              (widget.barTitle == "Login")
                                  ? "  Register"
                                  : "  Login",
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
          ],
        ),
      ),
    );
  }
}
