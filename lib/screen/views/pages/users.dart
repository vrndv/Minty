import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/screen/views/widgets/avatar.dart';
import 'package:SHADE/services/chat_services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      body: Stack(
        children: [
          Column(
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
          Positioned(
            bottom: 12,
            right: 25,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 200),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return userChatPage(
                        u1: "global",
                        u2: "global",
                        senderUsername: currentUser.value,
                        receiverUsername: "global",
                      );
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          final curved = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInCubic,
                            reverseCurve: Curves.easeOutCubic,
                          );

                          return ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(curved),
                            child: child,
                          );

                          // For fade transition, comment above and use:
                          // return FadeTransition(opacity: animation, child: child);
                        },
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.outlineVariant,
              child: Icon(
                Icons.public_sharp,
                color: currentTheme.value ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _userServices.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong...");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("...");
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) {
            chatLen.value = snapshot.data!.size;
            return _buildChatItem(doc);
          }).toList(),
        );
      },
    );
  }

  Widget _buildChatItem(DocumentSnapshot doc) {
    final rawData = doc.data();
    if (rawData == null) {
      return const SizedBox.shrink();
    }

    Map<String, dynamic> data = rawData as Map<String, dynamic>;

    List participants = data["participants"] ?? [];
    Map usernames = data["usernames"] ?? {};
    // Defensive fallback if something's missing
    if (participants.isEmpty ||
        !usernames.containsKey(userID.value) ||
        usernames.containsKey("global")) {
      return const SizedBox.shrink();
    }

    String otherUid = participants.firstWhere((uid) => uid != userID.value);
    String otherUsername = usernames[otherUid] ?? "Unknown";

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentTheme.value
            ? const Color.fromARGB(120, 211, 211, 212)
            : currentTheme.value
            ? Colors.grey[300]
            : const Color.fromARGB(255, 35, 36, 35),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Slidable(
        key: ValueKey(doc.id),
        endActionPane: ActionPane(
          dismissible: DismissiblePane(
            confirmDismiss: () async {
              return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Are you sure?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                            Slidable.of(context)?.close();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            ChatServices().deleteChat(roomID: doc.id);
                          },
                          child: Text("Confirm"),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            },

            onDismissed: () {},
            dismissThreshold: 0.1,
          ),
          motion: BehindMotion(),
          children: [
            SlidableAction(
              icon: Icons.delete,
              backgroundColor: Colors.red,
              onPressed: (context) {
                print(doc.id);
              },
              label: "Delete",
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () {
              Future.delayed(Duration(milliseconds: 200), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return userChatPage(
                        u1: otherUid,
                        u2: userID.value,
                        senderUsername: currentUser.value,
                        receiverUsername: otherUsername,
                      );
                    },
                  ),
                );
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: ListTile(
              leading: Avatar(seed: otherUsername, r: 25),
              title: Text(otherUsername),
              subtitle: Text(
                data["lastMsg"] ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                data["lastUpdated"] != null
                    ? _formatTimestamp(data["lastUpdated"])
                    : "",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
