import 'dart:convert';
import '../../../core/config/env.dart';
import 'package:http/http.dart' as http;

class EmitenDetailService {
  static Future<Map<String, dynamic>> fetchDetail(String ticker) async {
    final url = Uri.parse("${Env.baseUrl}/idx/emitens/$ticker/detail");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load emiten detail");
    }
  }
}