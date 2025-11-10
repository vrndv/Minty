import 'package:SHADE/screen/views/pages/aichatpage.dart';
import 'package:flutter/material.dart';
import 'package:SHADE/services/ai_services.dart';
import 'package:rive/rive.dart'; 

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  String reply = "";
  TextEditingController ctrl = TextEditingController();
  bool isLoading = false;

  Future<void> sendPrompt() async {
    setState(() {
      reply = "";
      isLoading = true;
    });

    final stream = chatAnywhereStream(ctrl.text); 

    // Listen to the live tokens
    await for (final token in stream) {
      setState(() {
        reply += token; 
      });
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Axel"),actions: [IconButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AiChat();
        },));
      }, icon: Icon(Icons.ac_unit_sharp))],),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: ctrl,
              decoration: const InputDecoration(
                labelText: "Enter your prompt",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : sendPrompt,
              child: isLoading
                  ? SizedBox(height: 20, width: 20,
                    child: RiveAnimation.asset(
                    'assets/rive/pumping.riv',
                    fit: BoxFit.contain,
                    speedMultiplier: 1.1,
                                    ),
                  )
                  : const Text("Ask" ,style: TextStyle(color: Colors.grey),),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  reply,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
