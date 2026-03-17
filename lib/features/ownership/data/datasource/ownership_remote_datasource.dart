import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/env.dart';
import '../models/ownership_model.dart';

class OwnershipRemoteDataSource {

  Future<OwnershipModel> fetchChart(String ticker) async {

    final uri = Uri.parse("${Env.baseUrl}/ownership/changes")
        .replace(queryParameters: {
      "ticker": ticker,
      "investor_type": "L",
      "start_date": "2025-12-18",
      "end_date": "2026-01-29",
      "limit": "100",
    });

    final response = await http.get(uri);
    
    if (response.statusCode != 200) {
      throw Exception("API Error: ${response.statusCode}");
    }

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return OwnershipModel.fromJson(jsonData["data"]);
    }

    throw Exception("Failed to load ownership chart");
  }
}