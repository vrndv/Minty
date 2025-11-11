import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Avatar extends StatelessWidget {
  final String seed;
  
  final double r;
  
  Color color;

   Avatar({required this.seed,required this.r,super.key , this.color = const Color.fromARGB(20, 131, 130, 130)});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: r,
      backgroundImage: NetworkImage("https://api.dicebear.com/9.x/adventurer/png?seed=$seed&scale=100"),
      backgroundColor: color,
    );
  }
}
//adventurer-neutral , adventurer , 