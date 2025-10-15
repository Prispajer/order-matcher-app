import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  final String apiKey;
  AppConfig({required this.apiKey});

  factory AppConfig.fromMap(Map<String, dynamic> map) {
    if (!map.containsKey('ai_key')) {
      return AppConfig(apiKey: '');
    }
    return AppConfig(apiKey: map['ai_key'] ?? '');
  }

  bool get isValid => apiKey.isNotEmpty && apiKey != 'PASTE_YOUR_KEY_HERE';
}

class AppConfigLoader {
  static Future<AppConfig> load() async {
    try {
      final raw = await rootBundle.loadString('assets/config/app_config.json');
      final map = jsonDecode(raw);
      return AppConfig.fromMap(map);
    } catch (e) {
      return AppConfig(apiKey: '');
    }
  }
}
