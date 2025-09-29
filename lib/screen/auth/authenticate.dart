import 'package:flutter/material.dart';
import 'package:SHADE/screen/auth/login.dart';
import 'package:SHADE/screen/auth/register.dart';
import 'package:rive/rive.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';

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
        title: Text(
          ' SHADE',
          style: TextStyle(
            fontSize: 24,
            color: currentTheme.value ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(40, 175, 173, 173),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Icon(
              Icons.all_inclusive,
              size: 100,
              color: currentTheme.value
                  ? const Color.fromARGB(104, 0, 0, 0)
                  : const Color.fromARGB(118, 255, 255, 255),
            ),
            Text(
              'Welcome to SHADE',
              style: TextStyle(
                color: currentTheme.value ? Colors.black : Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 80),
            ColorFiltered(
              colorFilter: !currentTheme.value
                  ? ColorFilter.matrix([
                      -1,
                      0,
                      0,
                      0,
                      255,
                      0,
                      -1,
                      0,
                      0,
                      255,
                      0,
                      0,
                      -1,
                      0,
                      255,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ])
                  : ColorFilter.linearToSrgbGamma(),
              child: const SizedBox(
                height: 200,
                width: 200,
                child: RiveAnimation.asset(
                  'assets/rive/pumping.riv',
                  fit: BoxFit.contain,
                  speedMultiplier: 1.1,
                ),
              ),
            ),
            Expanded(child: Text("")),
            //LOGIN
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
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
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: currentTheme.value
                        ? Colors.black
                        : const Color.fromARGB(209, 255, 255, 255),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: currentTheme.value ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            //REGISTER
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
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
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: currentTheme.value
                        ? Colors.black
                        : const Color.fromARGB(199, 255, 255, 255),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: currentTheme.value ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
