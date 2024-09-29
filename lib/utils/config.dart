import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Config {
  final String baseUri;

  Config({required this.baseUri});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      baseUri: json['baseUri'],
    );
  }
}

Future<Config> loadConfig() async {
  final jsonString = await rootBundle.loadString('assets/config.json');
  final jsonResponse = json.decode(jsonString);
  return Config.fromJson(jsonResponse);
}