import 'package:SHADE/screen/views/pages/aichatpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/screen/views/widgets/avatar.dart';
import 'package:SHADE/services/chat_services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

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

  var isUndo = false;

  @override
  Widget build(BuildContext context) {
    final bgcolor = currentTheme.value
        ? Colors.grey[200]
        : const Color.fromARGB(225, 20, 20, 20);
    return Scaffold(
      backgroundColor: bgcolor,
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
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 5),
              SearchBar(
                onTap: () {
                  isSearch.value = true;
                  setState(() {});
                },

                hintText: "Search",
                leading: Icon(Icons.search),
              ),
              SizedBox(height: 10),
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
                        pfp: "global",
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
          Positioned(
            bottom: 90,
            right: 30,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AiChat();
                    },
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Container(
                  height: 50,
                  width: 50,
                  child: Lottie.asset(
                    'assets/rive/orb.json',
                    width: 700,
                    height: 700,
                    fit: BoxFit.contain,
                  ),
                ),
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
    if (rawData == null) return const SizedBox.shrink();

    Map<String, dynamic> data = rawData as Map<String, dynamic>;

    List participants = data["participants"] ?? [];
    Map usernames = data["usernames"] ?? {};
    Map pfps = data["pfps"] ?? {};
    if (participants.isEmpty ||
        !usernames.containsKey(userID.value) ||
        usernames.containsKey("global")) {
      return const SizedBox.shrink();
    }

    String otherUid = participants.firstWhere((uid) => uid != userID.value);
    String otherUsername = usernames[otherUid] ?? "Unknown";
    String Otherpfp = pfps[otherUid] ?? otherUsername;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentTheme.value
            ? const Color.fromARGB(120, 211, 211, 212)
            : const Color.fromARGB(255, 35, 36, 35),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Slidable(
        key: ValueKey(doc.id),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          dismissible: DismissiblePane(
            dismissThreshold: 0.3,
            onDismissed: () async {
              final deletedChatData = data; // Store a copy before deleting
              final deletedChatId = doc.id;
              ChatServices().tempDeleteChat(roomID: deletedChatId);
              // Show snackbar with undo option
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Chat with $otherUsername deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () async {
                      restoreChat(
                        roomID: deletedChatId,
                        chatData: deletedChatData,
                      );
                      isUndo = true;
                    },
                  ),
                  duration: const Duration(seconds: 5),
                ),
              );
              Future.delayed(Duration(seconds: 5)).then((value) async {
                if (!isUndo) {
                  await ChatServices().deleteChat(roomID: deletedChatId);
                  isUndo = false;
                }
              });
            },
          ),
          children: [
            SlidableAction(
              icon: Icons.delete,
              backgroundColor: Colors.red,
              label: "Delete",
              onPressed: (_) async {
                final deletedChatData = data;
                final deletedChatId = doc.id;

                await ChatServices().tempDeleteChat(roomID: deletedChatId);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Chat with $otherUsername deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () async {
                        restoreChat(
                          roomID: deletedChatId,
                          chatData: deletedChatData,
                        );
                        isUndo = true;
                      },
                    ),
                    duration: const Duration(seconds: 5),
                  ),
                );
                Future.delayed(Duration(seconds: 5)).then((value) async {
                  if (!isUndo) {
                    await ChatServices().deleteChat(roomID: deletedChatId);
                    isUndo = false;
                  }
                });
              },
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () {
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return userChatPage(
                        u1: otherUid,
                        u2: userID.value,
                        senderUsername: currentUser.value,
                        receiverUsername: otherUsername,
                        pfp: Otherpfp,
                      );
                    },
                  ),
                );
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: ListTile(
              leading: Avatar(seed: Otherpfp, r: 25),
              title: Text(otherUsername),
              subtitle: Text(
                data["lastMsg"] != null
                    ? data["reciever"] == currentUser.value
                          ? "${data["lastMsg"]}"
                          : "You:${data["lastMsg"]}"
                    : "",
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
    return DateFormat('hh:mm a').format(timestamp.toDate());
  }
}
