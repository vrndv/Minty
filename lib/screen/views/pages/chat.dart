import 'dart:async';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/services/chat_services.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String roomID;
  const ChatPage({super.key, required this.roomID});
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
      await _chatServices.sendMessage(
        message: msgcontroller.text,
        roomID: widget.roomID,
      );
      msgcontroller.clear();
      scrollDown();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown({int time = 300}) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: time),
      curve: Curves.fastOutSlowIn,
    );
  }

  // final keyboardVisibilityController = Flutter
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentTheme,
      builder: (context, value, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildMessageList()),

                KeyboardVisibility(
                  onChanged: (p0) => {
                    if (p0 == true)
                      {
                        Future.delayed(
                          const Duration(milliseconds: 150),
                          () => scrollDown(time: 250),
                        ),
                      },
                  },
                  child: Container(
                    color: currentTheme.value
                        ? const Color.fromARGB(57, 165, 164, 164)
                        : const Color.fromARGB(125, 12, 12, 12),
                    padding: EdgeInsets.all(13),
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: TextField(
                              controller: msgcontroller,
                              decoration: InputDecoration(
                                hintText: value ? "Message" : "Enter Message",
                                contentPadding: EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                ),
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
                              color: currentTheme.value
                                  ? Color.fromARGB(24, 0, 0, 0)
                                  : Color.fromARGB(23, 109, 108, 108),
                            ),
                            child: Icon(Icons.send),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatServices.getMessage(roomID: widget.roomID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("...");
        }
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          ),
        );
        return ListView(
          controller: _scrollController,
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
        child: GestureDetector(
          onLongPress: () {
            msgcontroller.text = data["message"];
          },
          child: Container(
            margin: data['username'] == currentUser.value
                ? EdgeInsets.fromLTRB(50, 5, 10, 5)
                : EdgeInsets.fromLTRB(10, 5, 50, 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: data['username'] == currentUser.value
                  ? Colors.blue[100]
                  : currentTheme.value
                  ? Colors.grey[300]
                  : const Color.fromARGB(255, 35, 36, 35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['username'] == currentUser.value
                      ? "You"
                      : data['username'],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: data['username'] == currentUser.value
                        ? const Color.fromARGB(255, 73, 72, 134)
                        : currentTheme.value
                        ? const Color.fromARGB(255, 75, 75, 75)
                        : const Color.fromARGB(255, 233, 233, 233),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  data['message'],
                  style: TextStyle(
                    color: data['username'] == currentUser.value
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : currentTheme.value
                        ? const Color.fromARGB(255, 75, 75, 75)
                        : const Color.fromARGB(255, 233, 233, 233),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormat('hh:mm a').format(data['time'].toDate()),
                    style: TextStyle(
                      fontSize: 10,
                      color: data['username'] == currentUser.value
                          ? const Color.fromARGB(255, 73, 72, 134)
                          : currentTheme.value
                          ? const Color.fromARGB(255, 75, 75, 75)
                          : const Color.fromARGB(255, 233, 233, 233),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
