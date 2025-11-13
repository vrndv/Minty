import 'package:SHADE/screen/views/widgets/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/services/chat_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
    final bgcolor = currentTheme.value
        ? Colors.grey[200]
        : const Color.fromARGB(225, 20, 20, 20);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SHADE',
          style: TextStyle(
            color: currentTheme.value ? Colors.black : Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),

        backgroundColor: bgcolor,
        elevation: 0,
      ),
      body: Container(
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
                child: name.isEmpty
                    ? StreamBuilder(
                        stream: viewRecent().asStream(),
                        builder: (context, snapshot) {
                          var users = snapshot.data ?? [];
                          users = users.reversed.toList();
                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              var data = users[index];
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
                                          pfp: data["pfp"] ?? data["username"],
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Avatar(
                                    seed: data["pfp"] ?? data["username"],
                                    r: 20,
                                  ),
                                  title: Text(data["username"]),
                                  trailing: IconButton(
                                    onPressed: () {
                                      removeRecent(data["uid"]);
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.cancel),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("user")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text("No users found"));
                          }

                          // Extract and filter data before building the list
                          var allUsers = snapshot.data!.docs;
                          var filteredUsers = name.isEmpty
                              ? []
                              : allUsers.where((doc) {
                                  var username = doc['username']
                                      .toString()
                                      .toLowerCase();
                                  return (username.contains(
                                        name.toLowerCase(),
                                      ) &&
                                      username.toLowerCase() !=
                                          currentUser.value.toLowerCase());
                                }).toList();

                          return ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              var data = filteredUsers[index].data();
                              return GestureDetector(
                                onTap: () {
                                  addRecent(
                                    id: data["uid"],
                                    username: data["username"],
                                    pfp: data["pfp"] ?? data["username"],
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return userChatPage(
                                          u1: data["uid"],
                                          u2: userID.value,
                                          senderUsername: currentUser.value,
                                          receiverUsername: data["username"],
                                          pfp: data["pfp"] ?? data["username"],
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Avatar(
                                    seed: data["pfp"] ?? data["username"],
                                    r: 20,
                                  ),
                                  title: Text(data['username']),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void addRecent({
  required String id,
  required String username,
  required String pfp,
}) async {
  final pref = await SharedPreferences.getInstance();
  List<String> current = pref.getStringList("recentSearch") ?? [];
  final entry = {"uid": id, "username": username, "pfp": pfp};
  current.add(jsonEncode(entry));
  await pref.setStringList("recentSearch", current);
}

Future<List> viewRecent() async {
  final pref = await SharedPreferences.getInstance();
  List<String> current = pref.getStringList("recentSearch") ?? [];
  List recent = pref.getStringList("recentSearch") ?? [];
  return recent.map((e) => jsonDecode(e)).toList();
}

Future<void> removeRecent(String id) async {
  final pref = await SharedPreferences.getInstance();
  List<String> current = pref.getStringList("recentSearch") ?? [];
  current.removeWhere((element) {
    final data = jsonDecode(element);
    return data["uid"] == id;
  });
  await pref.setStringList("recentSearch", current);
}
