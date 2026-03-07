import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/env.dart';
import '../model/ownership_model.dart';

class OwnershipService {

  static Future<OwnershipChartResponse> fetchChart(String ticker) async {

    // final uri = Uri.parse(
    //   "https://your-api.com/ownership/chart?ticker=$ticker"
    // );

   final uri = Uri.parse("${Env.baseUrl}/ownership/monthly/changes")
      .replace(queryParameters: {
        "ticker": ticker,
        "investor_type": "L",
        "start_date": "2025-02-01",
        "end_date": "2026-04-28",
        "limit": "10",
      });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return OwnershipChartResponse.fromJson(jsonData);
    }

    throw Exception("Failed to load ownership chart");
  }
}