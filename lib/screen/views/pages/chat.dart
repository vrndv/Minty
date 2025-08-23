import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(centerTitle: true,title: Text("Global",style: TextStyle(fontSize: 20),),),
      body:Container(
        child: null,
      )
    );
  }
}