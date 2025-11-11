import 'dart:async';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/database.dart';
import 'package:SHADE/screen/views/widgets/avatar.dart';
import 'package:SHADE/services/chat_services.dart';
import 'package:intl/intl.dart';
import 'package:SHADE/services/profanity.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String roomID;
  final String senderUid;
  final String receiverUsername;
  final String senderUsername;
  final String receiverUid;
  final String pfp;

  const ChatPage({
    super.key,
    required this.roomID,
    required String this.senderUid,
    required String this.receiverUid,
    required String this.senderUsername,
    required String this.receiverUsername,
    required String this.pfp,
  });
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //chat services
  final _chatServices = ChatServices();

  ScrollController _scrollController = ScrollController();
  final TextEditingController msgcontroller = TextEditingController();
  //new:typing state
  ValueNotifier<bool> _isTyping = ValueNotifier(false);
  //Send Message
  bool i = true;

  Future<void> sendMessage(String msg) async {
    var text = msgcontroller.text;
    msgcontroller.clear();
    if (text.isNotEmpty || msg.isNotEmpty) {
      if (widget.roomID == 'global' &&
          ProfanityFilter.containsProfanity(text) &&
          isProfanity.value) {
        text = ProfanityFilter.censorText(text);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(99, 255, 0, 0),
              title: Text("Warning"),
              content: Text("Usage of Offensive language might result in ban"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Understood"),
                ),
              ],
            );
          },
        );
      }
      i ? isSearch.value = false : null;
      await _chatServices.sendMessage(
        message: text.isEmpty ? msg : text,
        roomID: widget.roomID,
        senderUid: userID.value,
        receiverUid: widget.receiverUid,
        senderUsername: currentUser.value,
        receiverUsername: widget.receiverUsername,
        isPhone: isPhone,
      );
      scrollDown();
    }
  }

  @override
  void initState() {
    super.initState();
    phone();
    _loadWallpaper();
    msgcontroller.addListener(() {
      _isTyping.value = msgcontroller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    msgcontroller.dispose();
    _isTyping.dispose();
    super.dispose();
  }

  bool isPhone = true;
  //wallpaper load
  File? _wallpaperImage;
  final ImagePicker _picker = ImagePicker();
  //

  void phone() async {
    isPhone = await DatabaseService().checkPhoneUser(
      username: widget.receiverUsername,
    );
  }
  //wallpaper methods

  Future<void> _pickWallpaper() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final savedImagePath = '${appDir.path}/wallpaper_${widget.roomID}.jpg';

      // 🧹 Delete old wallpaper if it exists
      final oldFile = File(savedImagePath);
      if (oldFile.existsSync()) {
        await oldFile.delete();
      }

      // 💾 Copy new wallpaper to app storage
      final savedImage = await File(pickedFile.path).copy(savedImagePath);

      // 💿 Save wallpaper path in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('wallpaper_${widget.roomID}', savedImage.path);

      // 🔁 Clear Flutter’s image cache (force reload)
      imageCache.clear();
      imageCache.clearLiveImages();

      // 🔄 Update the UI immediately
      setState(() {
        _wallpaperImage = savedImage;
      });
    }
  }

  Future<void> _loadWallpaper() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('wallpaper_${widget.roomID}');
    if (path != null && File(path).existsSync()) {
      setState(() {
        _wallpaperImage = File(path);
      });
    }
  }

  Future<void> _resetWallpaper() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('wallpaper_${widget.roomID}');

    // 🧹 Delete saved wallpaper file (if exists)
    if (path != null && File(path).existsSync()) {
      await File(path).delete();
    }

    // 🧽 Remove the saved entry from preferences
    await prefs.remove('wallpaper_${widget.roomID}');

    // 🔁 Clear Flutter image cache
    imageCache.clear();
    imageCache.clearLiveImages();

    // 🔄 Update UI to default background
    setState(() {
      _wallpaperImage = null;
    });
  }

  void scrollDown({int time = 300}) {
    // Add this check before scrolling
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: time),
        curve: Curves.fastOutSlowIn,
      );
    }
  } // final keyboardVisibilityController = Flutter

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentTheme,
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 15, top: 1, bottom: 1),
              child: Avatar(seed: widget.pfp, r: 20),
            ),
            title: Text(widget.receiverUsername),
            actions: [
              IconButton(
                onPressed: _pickWallpaper,
                icon: Icon(Icons.image),
                tooltip: "change wallpaper",
              ),
              IconButton(
                onPressed: _resetWallpaper,
                icon: const Icon(Icons.delete),
                tooltip: "reset wallpaper",
              ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              if (_wallpaperImage != null)
                Image.file(
                  _wallpaperImage!,
                  key: ValueKey(DateTime.now().microsecondsSinceEpoch),
                  fit: BoxFit.cover,
                )
              else
                Container(
                  color: currentTheme.value
                      ? Colors.grey[200]
                      : const Color.fromARGB(225, 20, 20, 20),
                ),
              SafeArea(
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
                                    hintText: value
                                        ? "Message"
                                        : "Enter Message",
                                    contentPadding: EdgeInsets.only(
                                      top: 10,
                                      left: 10,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: _isTyping,
                              builder: (context, isTyping, child) {
                                return IconButton(
                                  onPressed: isTyping
                                      ? () {
                                          sendMessage("");
                                        }
                                      : null, // 👈 disable when empty
                                  icon: TweenAnimationBuilder<Color?>(
                                    tween: ColorTween(
                                      begin: Colors.grey,
                                      end: isTyping ? Colors.blue : Colors.grey,
                                    ),
                                    duration: const Duration(milliseconds: 250),
                                    builder: (context, color, child) {
                                      return Icon(Icons.send, color: color);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  } // Modify your StreamBuilder's builder to handle scrolling after build

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
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: GestureDetector(
              onTap: () {
                sendMessage("Hi,I'm ${currentUser.value}!");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Say ", style: TextStyle(fontSize: 20)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 37, 37, 37),
                    ),
                    child: Text("Hi !", style: TextStyle(fontSize: 17)),
                  ),
                ],
              ),
            ),
          );
        }

        // Move this into a post-frame callback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          }
        });

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
