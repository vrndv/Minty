import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthWave extends StatelessWidget {
  const AuthWave({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/rive/grey-wave.json',
      fit: BoxFit.cover,
      repeat: true,
    );
  }
}