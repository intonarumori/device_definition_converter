import 'abbreviation_lookup.dart';

class Naming {
  static String createId(String name) {
    return sanitize(name.toLowerCase());
  }

  static String sanitize(String name) {
    final parts = name.split('_');
    return parts.map((e) => e.replaceAll(RegExp(r'[^a-z0-9_]'), '_')).join('_');
  }

  static String createAbbreviation(String name) {
    final parts = extractNameParts(name);
    return createAbbreviationForParts(parts);
  }

  static String createAbbreviationForParts(List<String> parts) {
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      final name = parts.first;
      return _abbreviatedName(name, limit: 4);
    }
    if (parts.length == 2) {
      final first = parts.first;
      final second = parts.last;
      return _abbreviatedName(first, limit: 2) + _abbreviatedName(second, limit: 2);
    }
    if (parts.length == 3) {
      final first = parts[0];
      final second = parts[1];
      final third = parts[2];
      return _abbreviatedName(first, limit: 1, enableWovelless: false) +
          _abbreviatedName(second, limit: 1, enableWovelless: false) +
          _abbreviatedName(third, limit: 2, enableWovelless: false);
    }
    if (parts.length >= 4) {
      return _abbreviatedName(parts[0], limit: 1, enableWovelless: false) +
          _abbreviatedName(parts[1], limit: 1, enableWovelless: false) +
          _abbreviatedName(parts[2], limit: 1, enableWovelless: false) +
          _abbreviatedName(parts[3], limit: 1, enableWovelless: false);
    }
    return '<no abbreviation>';
  }

  static String _abbreviatedName(String name, {int limit = 2, bool enableWovelless = true}) {
    final key = name.toLowerCase();
    if (AbbreviationLookup.map.containsKey(key)) {
      return truncate(AbbreviationLookup.map[key]!, limit);
    }

    String converted = name;

    if (converted.length <= limit) {
      return converted;
    }
    if (enableWovelless) {
      converted = getVowelless(converted);
      if (converted.length <= limit) {
        return converted;
      }
    }
    return truncate(converted, limit);
  }

  static String truncate(String name, int limit) {
    if (name.length < limit) {
      return name;
    }
    return name.substring(0, limit);
  }

  static String pascalCase(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  static String getVowelless(String name) {
    if (name.isEmpty) return '';
    // Keep the first letter if it's a vowel
    return name[0] + name.substring(1).replaceAll(RegExp(r'[aeiouAEIOU]'), '');
  }

  static List<String> extractNameParts(String name) {
    var cleanedName = name;
    // Remove parenthesis content
    cleanedName = cleanedName.replaceAll(RegExp(r'\([^()]*\)'), '').trim();
    while (RegExp(r'\([^()]*\)').hasMatch(cleanedName)) {
      cleanedName = cleanedName.replaceAll(RegExp(r'\([^()]*\)'), '').trim();
    }
    // Remove bracketed content
    cleanedName = cleanedName.replaceAll(RegExp(r'\[.*?\]'), '').trim();
    // Remove colons
    cleanedName = cleanedName.replaceAll(':', '');

    // Remove dots
    cleanedName = cleanedName.replaceAll('.', ' ');

    // Remove parts matching &# followed by digits and a semicolon
    cleanedName = cleanedName.replaceAll(RegExp(r'&#\d+;'), '');

    // Remove mismatched parenthesis
    if (cleanedName.contains(')')) {
      cleanedName = cleanedName.replaceAll(')', '');
    }

    if (cleanedName.contains(')') ||
        cleanedName.contains('(') ||
        cleanedName.contains('[') ||
        cleanedName.contains(']')) {}
    //
    final parts =
        cleanedName.split(' ').map((e) => pascalCase(e).trim()).where((e) => e.isNotEmpty).toList();
    return parts;
  }
}
