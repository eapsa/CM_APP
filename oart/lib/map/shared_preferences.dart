import 'package:shared_preferences/shared_preferences.dart';

const List<String> languages = <String>[
  "en",
  "pt",
  "fr",
  "es",
  "de",
];

class SharedPreferencesHelper {
  static Future<bool> getTTS() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("tts") ?? false;
  }

  static Future<bool> setTTS(bool tts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("tts", tts);
  }

  static Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("lang") ?? "en";
  }

  static Future<bool> setLanguage(String lang) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("lang", lang);
  }
}
