import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/ownership_model.dart';

class OwnershipChangeChart extends StatelessWidget {
  final List<OwnershipData> data;

  const OwnershipChangeChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(),
      series: <ColumnSeries<OwnershipData, DateTime>>[
        ColumnSeries<OwnershipData, DateTime>(
          dataSource: data,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => data.change,
        ),
      ],
    );
  }
}
