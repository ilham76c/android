import 'package:flutter/material.dart';

import '../../domain/usecases/get_ownership_chart.dart';
import '../../domain/entities/ownership_entity.dart';

class OwnershipController extends ChangeNotifier {
  final GetOwnershipChart getOwnershipChart;

  OwnershipController(this.getOwnershipChart);

  OwnershipEntity? data;
  bool isLoading = false;
  String? error;

  Future<void> load(String ticker) async {
    try {
      isLoading = true;
      notifyListeners();

      data = await getOwnershipChart(ticker);

      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWithRange(
    String ticker, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      data = await getOwnershipChart(
        ticker,
        startDate: startDate,
        endDate: endDate,
      );

      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}