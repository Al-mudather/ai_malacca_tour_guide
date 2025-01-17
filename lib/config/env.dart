import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class Environment {
  static String get fileName {
    if (const String.fromEnvironment('FLAVOR', defaultValue: 'development') ==
        'production') {
      return '.env.production';
    }
    return '.env.development';
  }

  static Future<void> initialize() async {
    await dotenv.dotenv.load(fileName: fileName);
  }

  static String get openAIKey {
    return dotenv.dotenv.env['OPENAI_API_KEY'] ?? '';
  }
}
