import 'dart:convert';

class HelperStringUtils {
  static jsonEncode(Map<String, dynamic> data) {
    return json.encode(data);
  }

  static Map<String, dynamic> jsonDecode(String jsonData) {
    return json.decode(jsonData);
  }

  static String format([dynamic values]) {
    return values.map((value) => value.toString()).join('\n\n');
  }

  static String formatMapToString(Map<String, dynamic> data) {
    List<String> formattedPairs = [];

    data.forEach((key, value) {
      formattedPairs.add("[$key]: [$value]");
    });

    return formattedPairs.join('\n');
  }
}
