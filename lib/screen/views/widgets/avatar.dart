import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String seed;
  
  final double r;

  const Avatar({required this.seed,required this.r,super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: r,
      backgroundImage: NetworkImage("https://api.dicebear.com/9.x/adventurer/png?seed=$seed&scale=100"),
      backgroundColor: const Color.fromARGB(20, 131, 130, 130),
    );
  }
}
//adventurer-neutral , adventurer , 