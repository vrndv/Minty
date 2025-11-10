import 'dart:convert';
import 'dart:async';
import 'package:SHADE/dataNotifiers/notifier.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum ApiProvider { pop1, pop1alt }

/// Selector
Stream<String> chatAnywhereStream(
  String message, {
  ApiProvider apiProvider = ApiProvider.pop1,
}) {
  switch (apiProvider) {
    case ApiProvider.pop1:
      return pop1Stream(message);
    case ApiProvider.pop1alt:
      return pop1AltStream(message);
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

  String prompt =
      "You are Cipher Ai model:PoP-01, Previous chat: [${history.join(', ')}]. "
      "User says: ${message}. Reply naturally and independently. "
      "Only use past info if directly needed to answer; do not mention, repeat or acknowledge past messages explicitly.";
  addItem(message);

  final url = Uri.parse('https://apifreellm.com/api/chat');
  final body = jsonEncode({'message': prompt});

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final fullText = data['response'] ?? '';
      for (final token in fullText.split(' ')) {
        yield '$token ';
        await Future.delayed(Duration(milliseconds: 50));
      }
    } else {
      if (response.statusCode == 500) {
        print("error 500, trying to re call ");
        yield "*ERR-500 retrying...* \n\n\n";
        yield* pop1Stream(message);
      } else {
        yield 'ⓘ ${response.statusCode} - ${response.body}';
      }
    }
  } catch (e) {
    yield "Error: Could not access API or process the request. Details: $e";
  }
}

// OpenRouter - pop1alt


Stream<String> pop1AltStream(String message) async* {
  List history = AiSessionHistory.value;

  const String openRouterApiKey = "redacted";

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

