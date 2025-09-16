import 'package:characters/characters.dart'; // Add to pubspec.yaml if not already

class ProfanityFilter {
  static final List<String> badWords = [
    "fuck","shit","bitch","asshole","bastard","dick","pussy","cock","cunt",
    "slut","whore","motherfucker","douche","bollocks","wanker","prick","twat",
    "jackass","fag","retard","nigger","nigga","niga"
  ];

  static final Map<String, String> leetMap = {
    '0': 'o','1': 'i','3': 'e','4': 'a','5': 's','7': 't','9': 'g',
    '@': 'a','\$': 's','!': 'i','*': '',
    'æ': 'ae','Æ': 'ae','ñ': 'n','ø': 'o','ł': 'l'
  };

  static String normalize(String text) {
    String lower = text.toLowerCase();
    String mapped = lower.characters.map((char) {
      return leetMap[char] ?? char;
    }).join();
    return mapped.replaceAll(RegExp(r'[^a-z]'), '');
  }

  /// ✅ Just check for profanity
  static bool containsProfanity(String text) {
    final normalized = normalize(text);
    return badWords.any((word) => normalized.contains(word));
  }

  /// ✂️ Replace bad words with asterisks (handles leetspeak too)
  static String censorText(String text) {
    String censored = text;
    final normalized = normalize(text);

    for (var word in badWords) {
      int startIndex = normalized.indexOf(word);
      while (startIndex != -1) {
        // Replace corresponding range in the original string with ****
        final replacement = '*' * word.length;

        // Naive approach: just replace all case-insensitive matches of word
        final regex = RegExp(word, caseSensitive: false);
        censored = censored.replaceAll(regex, replacement);

        // Look for next occurrence
        startIndex = normalized.indexOf(word, startIndex + word.length);
      }
    }

    return censored;
  }
}
