import 'package:SHADE/screen/views/widgets/auth_wave.dart';
import 'package:SHADE/screen/views/widgets/login_btn.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/screen/auth/login.dart';
import 'package:SHADE/screen/auth/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool show = false;
  bool flicker = false;
  AnimatedTextController? MyAnim;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        show = true;
      });
    });
    flickerTimer();
    super.initState();
  }

  flickerTimer() async {
    while (true) {
      try {
        await Future.delayed(Duration(seconds: 10), () => playFlicker());
      } catch (e) {}
    }
  }

  playFlicker() {
    setState(() {
      show = false;
      flicker = !flicker;
    });
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        show = true;
      });
    });
  }

  final nxtpg = Login(
    icon: Icons.login,
    barTitle: "Login",
    subText: "Don't have an account?",
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // LottieBuilder.asset(
            //   'assets/rive/bg-sparkle.json',
            //   height: double.infinity,
            //   fit: BoxFit.fill,
            // ),
            AuthWave(), // Hero background

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 300),

                  ValueListenableBuilder(
                    valueListenable: currentTheme,
                    builder: (context, value, child) {
                      return Stack(
                        children: [
                          Container(
                            width: 240,
                            height: 80,
                            //decoration: BoxDecoration(color: Colors.amber),
                            child: Text(
                              " Step into",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          show
                              ? Positioned(
                                  top: 15,
                                  child: GestureDetector(
                                    onTap: () {
                                      print(currentTheme.value);
                                      playFlicker();
                                    },
                                    child: Text(
                                      'SHADE',
                                      style: GoogleFonts.orbitron(
                                        textStyle: TextStyle(
                                          color: value
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 55,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Positioned(
                                  top: 15,
                                  child: AnimatedTextKit(
                                    totalRepeatCount: 1,
                                    controller: MyAnim,
                                    key: ValueKey(flicker),
                                    animatedTexts: [
                                      FlickerAnimatedText(
                                        'SHADE',
                                        textStyle: GoogleFonts.orbitron(
                                          textStyle: TextStyle(
                                            color: value
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 55,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      );
                    },
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 7.0,
                            color: Colors.white,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          RotateAnimatedText('Where privacy meets connection.'),
                          RotateAnimatedText('Talk, trust, together'),
                          RotateAnimatedText('Big privacy, small phones.'),
                          RotateAnimatedText(
                            'Messages disappear. Trust remains.',
                            textStyle: TextStyle(fontSize: 15),
                          ),
                          RotateAnimatedText('Every chat, a safe space.'),
                          RotateAnimatedText('Even your old phone fits in.'),
                          RotateAnimatedText("Every chat, a safe space."),
                          RotateAnimatedText("Chat anywhere. No fuss."),
                        ],

                        repeatForever: true,
                        pause: const Duration(milliseconds: 1000),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                    ),
                  ),
                  Expanded(child: Text(""), flex: 1),
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
                      child: Hero(
                        tag: "login_btn",
                        child: Login_btn(text: "Login"),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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
                      child: Hero(
                        tag: "reg_btn",
                        child: Login_btn(text: "Register"),
                      ),
                    ),
                  ),
                  Expanded(child: Text(""), flex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
