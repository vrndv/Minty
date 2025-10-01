import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/services/chat_services.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  String name = "";
  final FocusNode focus = FocusNode();
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focus.requestFocus();
    });
  }

  @override
  void dispose() {
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            SearchBar(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.all(Radius.zero),
                ),
              ),
              onTap: () {},
              focusNode: focus,
              hintText: "Search",
              leading: Icon(Icons.search),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No users found"));
                  }

                  // Extract and filter data before building the list
                  var allUsers = snapshot.data!.docs;
                  var filteredUsers = name.isEmpty
                      ? allUsers
                      : allUsers.where((doc) {
                          var username = doc['username']
                              .toString()
                              .toLowerCase();
                          return (username.contains(name.toLowerCase()) &&
                              username.toLowerCase() !=
                                  currentUser.value.toLowerCase());
                        }).toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      var data = filteredUsers[index].data();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return userChatPage(
                                  u1: data["uid"],
                                  u2: userID.value,
                                  senderUsername: currentUser.value,
                                  receiverUsername: data["username"],
                                  pfp: data["pfp"]??data["username"],
                                );
                              },
                            ),
                          );
                        },
                        child: ListTile(title: Text(data['username'])),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
