import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';
import 'package:popapp/services/chat_services.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final _userServices = UserServices();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchcontroller = TextEditingController();
  void scrollDown({int time = 300}) {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: time),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchBar(
            onTap: () {
              isSearch.value = true;
              setState(() {});
            },

            hintText: "Search",
            leading: Icon(Icons.search),
            onChanged: (value) => print(value),
          ),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _userServices.getUsers(),
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
              .map((doc) => _buildUserItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentTheme.value
            ? Colors.blue[100]
            : currentTheme.value
            ? Colors.grey[300]
            : const Color.fromARGB(255, 35, 36, 35),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: ListTile(
        title: Text(
          data["username"] == currentUser.value
              ? "GLOBAL CHAT"
              : data['username'],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return userChatPage(u1: data["uid"], u2: userID.value);
              },
            ),
          );
        },
        onLongPress: () => print(isSearch.value),
      ),
    );
  }

 
}
