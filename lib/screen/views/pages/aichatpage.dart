import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:SHADE/services/ai_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AiChat extends StatefulWidget {
  const AiChat({super.key});

  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  String reply = "";
  TextEditingController msgcontroller = TextEditingController();
  bool isLoading = false;
  List message = [];
  ApiProvider model = ApiProvider.pop1;

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isTyping = ValueNotifier(false);

  void scrollDown({int time = 300}) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: time),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  toggle() {
    if (model == ApiProvider.pop1) {
      model = ApiProvider.pop1alt;
    } else {
      model = ApiProvider.pop1;
    }
    setState(() {});
  }

  Future<void> sendPrompt() async {
    final text = msgcontroller.text;
    msgcontroller.clear();
    setState(() {
      reply = "";
      isLoading = true;
      message.add({"text": "", "isUser": false, "time": Timestamp.now()});
    });
    Future.delayed(const Duration(milliseconds: 100), scrollDown);

    final stream = chatAnywhereStream(text, apiProvider: model);

    await for (final token in stream) {
      setState(() {
        reply += token;
        message.last["text"] = reply;
      });
    }

    setState(() => isLoading = false);
  }

  void check() async {
    try {
      print("called");
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      int count = (50 - (prefs.getInt(today) ?? 0));
      Balance.value = count.toString();
      print(count);
      // ignore: empty_catches
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _isTyping.value = msgcontroller.text.trim().isNotEmpty;
    msgcontroller.addListener(() {
      _isTyping.value = msgcontroller.text.trim().isNotEmpty;
    });
    check();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    msgcontroller.dispose();
    _isTyping.dispose();
    AiSessionHistory.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentTheme,
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Cipher"),
            actions: [
              GestureDetector(
                onTap: () => toggle(),
                child: Text(
                  model.name == "pop1"
                      ? "PoP-01"
                      : "PoP-01-Alt (${Balance.value})",
                  style: TextStyle(
                    color: Balance.value == "0"
                        ? model.name == "pop1alt"
                              ? const Color.fromARGB(175, 244, 67, 54)
                              : null
                        : null,
                  ),
                ),
              ),
              IconButton(onPressed: toggle, icon: Icon(Icons.sync_outlined)),
              SizedBox(width: 10),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Chat messages
                Expanded(
                  child: message.isEmpty
                      ? _buildEmptyPlaceholder(value)
                      : _buildMessageList(),
                ),

                // Input field
                KeyboardVisibility(
                  onChanged: (p0) {
                    if (p0) {
                      Future.delayed(
                        const Duration(milliseconds: 150),
                        () => scrollDown(time: 250),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(13),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 7,
                            minLines: 1,
                            controller: msgcontroller,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: value
                                  ? const Color.fromARGB(108, 165, 164, 164)
                                  : const Color.fromARGB(255, 33, 33, 33),
                              hintText: value ? "Message" : "Enter Message",
                              contentPadding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: _isTyping,
                          builder: (context, isTyping, child) {
                            return Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: value
                                    ? const Color.fromARGB(108, 165, 164, 164)
                                    : const Color.fromARGB(110, 70, 69, 69),
                              ),
                              child: IconButton(
                                onPressed: isTyping && !isLoading
                                    ? () {
                                        setState(() {
                                          message.add({
                                            "text": msgcontroller.text,
                                            "isUser": true,
                                            "time": Timestamp.now(),
                                          });
                                          sendPrompt();
                                        });
                                      }
                                    : null,
                                icon: TweenAnimationBuilder<Color?>(
                                  tween: ColorTween(
                                    begin: value
                                        ? const Color.fromARGB(
                                            108,
                                            165,
                                            164,
                                            164,
                                          )
                                        : const Color.fromARGB(
                                            255,
                                            193,
                                            192,
                                            192,
                                          ),
                                    end: isTyping && !isLoading
                                        ? Colors.blue
                                        : value
                                        ? const Color.fromARGB(
                                            108,
                                            165,
                                            164,
                                            164,
                                          )
                                        : const Color.fromARGB(
                                            255,
                                            193,
                                            192,
                                            192,
                                          ),
                                  ),
                                  duration: const Duration(milliseconds: 250),
                                  builder: (context, color, child) {
                                    return Icon(Icons.send, color: color);
                                  },
                                ),
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
        );
      },
    );
  }

  Widget _buildEmptyPlaceholder(bool isLightTheme) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLightTheme
                    ? const Color.fromARGB(255, 230, 230, 230)
                    : const Color.fromARGB(255, 33, 33, 33),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("Chat with Privacy !"),
            ),
            const SizedBox(height: 100),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "• We don’t store, log, or share any user data. \n\n"
                "• All inputs and outputs are processed in memory only. \n\n"
                "• Your data is permanently deleted after each session. \n\n"
                "• No tracking, No analytics.",
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List of chat messages
  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: message.length,
      itemBuilder: (context, index) {
        return _buildMessageItem(message[index]);
      },
    );
  }

  // Single message bubble
  Widget _buildMessageItem(Map<String, dynamic> data) {
    bool isUser = data['isUser'] == true;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: GestureDetector(
          onLongPress: () => msgcontroller.text = data["text"],
          child: Container(
            margin: isUser
                ? const EdgeInsets.fromLTRB(50, 5, 10, 5)
                : const EdgeInsets.fromLTRB(10, 5, 50, 5),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: isUser
                  ? const Color.fromARGB(92, 51, 51, 51)
                  : const Color.fromARGB(0, 0, 0, 0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: data["text"] == ""
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: RiveAnimation.asset(
                      'assets/rive/pumping.riv',
                      fit: BoxFit.contain,
                      speedMultiplier: 1.1,
                    ),
                  )
                : MarkdownBody(
                    data: data["text"],

                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      a: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                      p: TextStyle(
                        fontSize: 16,
                        color: data["text"][0] == "ⓘ"
                            ? Colors.red
                            : currentTheme.value
                            ? Colors.black
                            : Colors.white,
                      ),
                      h1: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.value ? Colors.black : Colors.white,
                      ),
                      h2: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.value ? Colors.black : Colors.white,
                      ),
                      h3: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.value ? Colors.black : Colors.white,
                      ),
                      code: TextStyle(
                        fontFamily: 'monospace',
                        backgroundColor: currentTheme.value
                            ? Colors.grey.shade200
                            : Colors.grey.shade800,
                        color: currentTheme.value ? Colors.black : Colors.white,
                      ),
                      blockquote: TextStyle(
                        color: currentTheme.value
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                        fontStyle: FontStyle.italic,
                      ),
                      listBullet: TextStyle(
                        fontSize: 16,
                        color: currentTheme.value ? Colors.black : Colors.white,
                      ),
                      tableHead: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: currentTheme.value ? Colors.black : Colors.white,
                      ),
                      tableBody: TextStyle(
                        color: currentTheme.value ? Colors.black : Colors.white,
                      ),
                    ),
                    onTapLink: (text, href, title) async {
                      if (href != null) {
                        final url = Uri.parse(href);
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        )) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Couldn't open link: $href"),
                            ),
                          );
                        }
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
