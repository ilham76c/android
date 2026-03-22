import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/env.dart';
import '../models/ownership_model.dart';

class OwnershipRemoteDataSource {

  Future<OwnershipModel> fetchChart(
    String ticker, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {

    final uri = Uri.parse("${Env.baseUrl}/ownership/changes")
        .replace(queryParameters: {
      "ticker": ticker,
      if (startDate != null) "start_date": _formatDate(startDate),
      if (endDate != null) "end_date": _formatDate(endDate),
      "investor_type": "L",
      "limit": "10",
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return OwnershipModel.fromJson(jsonData["data"]);
    }

    throw Exception("Failed to load ownership chart");
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${_two(date.month)}-${_two(date.day)}";
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}