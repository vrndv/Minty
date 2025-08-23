import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/services/chat_services.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //chat services
  final _chatServices = ChatServices();
  final TextEditingController msgcontroller = TextEditingController();
  //Send Message
  Future<void> sendMessage() async {
    if (msgcontroller.text.isNotEmpty) {
      print("hmmm....");
      await _chatServices.sendMessage(message: msgcontroller.text);
      print("send");
      msgcontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black38,
        elevation: 2,
        title: Text("Global Chat", style: TextStyle(fontSize: 20)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),

            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(0),
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: TextField(
                        controller: msgcontroller,
                        decoration: InputDecoration(
                          hintText: "Message",
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(24, 0, 0, 0),
                      ),
                      child: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatServices.getMessage(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("...");
        }
        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  //build message item

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Align(
      alignment: data['username'] == currentUser.value
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          margin: data['username'] == currentUser.value
              ? EdgeInsets.fromLTRB(50, 5, 10, 5)
              : EdgeInsets.fromLTRB(10, 5, 50, 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(                        
            color: data['username'] == currentUser.value
                ? Colors.blue[100]
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),  
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['username'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 5),
              Text(data['message']),

              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('hh:mm a').format(data['time'].toDate()),
                  style: TextStyle(fontSize: 10, color: Colors.black45),
                ),
              ),
            ],
          ),        
            ),
      ));
  }
}
