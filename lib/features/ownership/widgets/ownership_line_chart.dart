import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/ownership_model.dart';
import 'package:intl/intl.dart';

class OwnershipLineChart extends StatelessWidget {
  final List<OwnershipData> data;

  const OwnershipLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<OwnershipData>>{};

    for (var item in data) {
      grouped.putIfAbsent(item.investor, () => []);
      grouped[item.investor]!.add(item);
    }

    return SfCartesianChart(
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
      ),
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.compact(),
      ),
      series: grouped.entries.map((entry) {
        return LineSeries<OwnershipData, DateTime>(
          name: entry.key,
          dataSource: entry.value,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => data.value,
          width: 2,
        );
      }).toList(),
    );
  }
}
