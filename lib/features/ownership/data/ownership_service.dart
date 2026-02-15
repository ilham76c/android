import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/ownership_model.dart';

class OwnershipService {
  static const String baseUrl = "http://10.0.2.2:8000/api/v1";

  static Future<List<OwnershipData>> fetchOwnership(
      String ticker) async {
    final uri = Uri.parse("$baseUrl/ownership/changes")
        .replace(queryParameters: {
          "ticker": ticker,
          "investor_type": "L",
          "start_date": "2026-01-01",
          "end_date": "2026-01-31",
          "limit": "50",
        });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded =
          json.decode(response.body);

      if (decoded["success"] == true) {
        final List<dynamic> data = decoded["data"];

        return data
            .map((item) => OwnershipData.fromJson(item))
            .toList();
      } else {
        throw Exception("API returned success=false");
      }
    } else {
      throw Exception("Failed to fetch ownership");
    }
  }
}
