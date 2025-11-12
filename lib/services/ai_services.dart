import 'dart:convert';
import 'dart:async';
import 'package:SHADE/dataNotifiers/aicred.dart';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ApiProvider {popMain, pop1, pop1alt }

/// Selector
Stream<String> chatAnywhereStream(
  String message, {
  ApiProvider apiProvider = ApiProvider.pop1,
}) {
  switch (apiProvider) {
    case ApiProvider.popMain:
      return popMainStream(message);
    case ApiProvider.pop1:
      return pop1Stream(message);
    case ApiProvider.pop1alt:
      return pop1AltStream(message);
  }
}

///PoP-Main (groq)

Stream<String> popMainStream(String message) async* {
  List history = AiSessionHistory.value;
  final String groqApiKey = aigroq.value;

  // Save new message to history safely
  void addItem(String item) {
    history.add(item);
    if (history.length > 5) {
      history = history.sublist(history.length - 5);
    }
    AiSessionHistory.value = history;
  }

 
  final messages = [
    {
      'role': 'system',
      'content':
          'You are a friendly chatbot. Reply in 1 short, casual sentence. Keep it conversational and natural.'
    },
    for (var msg in history)
      {'role': 'user', 'content': msg.toString()},
    {'role': 'user', 'content': message},
  ];

  addItem(message);

  final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
  final request = http.Request('POST', url)
    ..headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $groqApiKey',
    })
    ..body = jsonEncode({
      'model': 'llama-3.1-8b-instant',
      'messages': messages,
      'temperature': 0.5,
      'max_completion_tokens': 150,
      'stream': true,
    });

  try {
    final streamedResponse = await request.send();

    // Handle usage/rate limit info (if any)
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    int count = prefs.getInt(today) ?? 0;
    count += 1;
    prefs.setInt(today, count);

    if (streamedResponse.statusCode == 200) {
      String buffer = '';

      await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
        buffer += chunk;

        while (true) {
          final newlineIndex = buffer.indexOf('\n');
          if (newlineIndex == -1) break;

          final line = buffer.substring(0, newlineIndex).trim();
          buffer = buffer.substring(newlineIndex + 1);

          if (line.isEmpty || !line.startsWith('data:')) continue;

          final jsonString = line.substring(5).trim();
          if (jsonString == '[DONE]') return;

          try {
            final data = jsonDecode(jsonString);
            final content = data['choices']?[0]?['delta']?['content'];
            if (content != null && content.isNotEmpty) {
              yield content;
            }
          } catch (_) {
            // Incomplete JSON chunk—wait for next iteration
            break;
          }
        }
      }
    } else {
      final errorText = await streamedResponse.stream.bytesToString();
      yield 'ⓘ ${streamedResponse.statusCode} - $errorText';
    }
  } catch (e) {
    yield 'Error: Could not access Groq API. Details: $e';
  }
}




/// APIFreeLLM - pop1

Stream<String> pop1Stream(String message) async* {
  List history = AiSessionHistory.value;

  void addItem(String item) {
    history.add(item);
    if (history.length > 5) history = history.sublist(history.length - 5);
    AiSessionHistory.value = history;
  }

  // Build prompt
     
  final lastMessages = history.length >= 3
    ? history.sublist(history.length - 3)
    : history;

// Build chat history string safely
final chatHistoryString = lastMessages
    .map((msg) => '"user": "${msg}"')
    .join(", ");
  addItem(message);

  final url = Uri.parse('https://mlvoca.com/api/generate');
  final body = jsonEncode({
  "model": "deepseek-r1:1.5b",
  "prompt": "You are a friendly chatbot. Reply in 1 short, casual sentence.  Only use past chat if needed. Do no repeat old messages.  Chat history: [ $chatHistoryString ]  Currently user says: ${message} give importance to current message",
  "temperature": 0.1,
  "max_tokens": 50,
});

  try {
    final request = http.Request('POST', url)
      ..headers['Content-Type'] = 'application/json'
      ..body = body;

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      final stream = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      bool inThinking = false;
      bool thinkingShown = false;

      await for (final line in stream) {
        if (line.trim().isEmpty) continue;

        try {
          final jsonLine = jsonDecode(line);
          final token = jsonLine['response'] ?? '';

          if (jsonLine['done'] == true) break;

          if (token.contains('<think>')) {
            inThinking = true;
            if (!thinkingShown) {
              yield "*Thinking...* \n";
              thinkingShown = true;
            }
            continue;
          }

          if (token.contains('</think>')) {
            inThinking = false;
            continue;
          }

          if (inThinking) continue; // Skip internal thoughts

          if (token.isNotEmpty) {
            yield token;
            await Future.delayed(const Duration(milliseconds: 40));
          }
        } catch (_) {
          yield "[stream error chunk]";
        }
      }
    } else {
      if (streamedResponse.statusCode == 500) {
        print("error 500, trying to re-call");
        yield "*ERR-500 retrying...* \n\n\n";
        yield* pop1Stream(message);
      } else {
        final errorText =
            await streamedResponse.stream.bytesToString();
        yield 'ⓘ ${streamedResponse.statusCode} - $errorText';
      }
    }
  } catch (e) {
    yield "Error: Could not access API or process the request. Details: $e";
  }
}
// OpenRouter - pop1alt


Stream<String> pop1AltStream(String message) async* {
  List history = AiSessionHistory.value;
  final String openRouterApiKey = aicred.value ; 

  void addItem(String item) {
    history.add(item);
    if (history.length > 5) history = history.sublist(history.length - 5);
    AiSessionHistory.value = history;
  }
  List<Map<String, String>> messages = [
    for (var item in history) {'role': 'user', 'content': item.toString()},
    {'role': 'user', 'content': message},
  ];
  addItem(message);

  final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
  final request = http.Request('POST', url)
    ..headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openRouterApiKey',
    })
    ..body = jsonEncode({
      'model': 'google/gemma-3n-e4b-it:free',
      'messages': messages,
      'stream': true,
    });

  try {
    final streamedResponse = await request.send();
    print(streamedResponse.headers);


    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    int count = prefs.getInt(today) ?? 0;
    final limitHeader = streamedResponse.headers['x-ratelimit-limit'];
    final remainingHeader = streamedResponse.headers['x-ratelimit-remaining'];
    if (limitHeader != null && remainingHeader != null) {
      Balance.value = '$remainingHeader';
    } else {
      const dailyLimit = 50;
      count += 1;
      prefs.setInt(today, count);
      final remaining = dailyLimit - count;
      Balance.value = '$remaining';
    }

    if (streamedResponse.statusCode == 200) {
      String buffer = '';

      await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
        buffer += chunk;

        while (true) {
          int newlineIndex = buffer.indexOf('\n');
          if (newlineIndex == -1) break;

          String line = buffer.substring(0, newlineIndex).trim();
          buffer = buffer.substring(newlineIndex + 1);

          if (line.isEmpty || !line.startsWith('data:')) continue;

          final jsonString = line.substring(5).trim();
          if (jsonString == '[DONE]') return;

          try {
            final data = jsonDecode(jsonString);
            final content = data['choices']?[0]?['delta']?['content'];
            if (content != null) yield content;
          } catch (_) {
            buffer = line + '\n' + buffer;
            break;
          }
        }
      }
    } else {
      final errorBody = await streamedResponse.stream.bytesToString();
      var index = errorBody.indexOf("X-RateLimit-Remaining");
      if (index != -1) {
        Balance.value = errorBody
            .substring(index + 24, index + 26)
            .replaceAll("\"", "");
      }

      yield 'ⓘ  ${streamedResponse.statusCode} - ${streamedResponse.statusCode == 429 ? "Rate limit exceeded, use other model" : "Something went wrong: $errorBody"}';
    }
  } catch (e) {
    yield "Error: Could not access OpenRouter API. Details: $e";
  }
}

