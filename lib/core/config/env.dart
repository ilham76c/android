import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://localhost:8000';

  static bool get isProduction =>
      dotenv.env['ENV'] == 'production';
}
