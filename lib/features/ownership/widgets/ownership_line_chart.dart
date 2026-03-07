import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../model/ownership_model.dart';

class OwnershipLineChart extends StatelessWidget {
  final OwnershipChartResponse data;

  const OwnershipLineChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    final series = data.series.map((s) {

      final points = List<OwnershipChartPoint>.generate(
        data.periods.length,
        (i) {
          final shares = s.shares[i];
          final percent = (shares / data.totalShares) * 100;

          return OwnershipChartPoint(
            date: data.periods[i],
            shares: shares,
            percent: percent,
            investor: s.investor,
          );
        },
      );

      return SplineSeries<OwnershipChartPoint, DateTime>(
        name: s.investor,
        dataSource: points,
        xValueMapper: (p, _) => p.date,
        yValueMapper: (p, _) => p.percent,
        width: 2,
        markerSettings: const MarkerSettings(isVisible: true),
      );

    }).toList();

    return SfCartesianChart(
      legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),

      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat('MMM yyyy'),
      ),

      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 100,
        interval: 10,
        labelFormat: '{value}%',
      ),

      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
      ),

      series: series,
    );
  }
}