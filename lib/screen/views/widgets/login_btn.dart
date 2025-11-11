 import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:flutter/material.dart';
class Login_btn extends StatelessWidget {
  final String text;
  const Login_btn({super.key , required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: currentTheme.value
                                  ? Colors.black
                                  : const Color.fromARGB(199, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              text,
                              style: TextStyle(
                                color: currentTheme.value
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
    );
  }
}