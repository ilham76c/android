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

    // 🔥 Pastikan setiap investor terurut berdasarkan tanggal
    for (var list in grouped.values) {
      list.sort((a, b) => a.date.compareTo(b.date));
    }

    double minValue = data.map((e) => e.shares).reduce((a, b) => a < b ? a : b);
    double maxValue = data.map((e) => e.shares).reduce((a, b) => a > b ? a : b);

    return SfCartesianChart(
      legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      // tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.days,
        interval: 1,
        dateFormat: DateFormat('dd MMM'),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.compact(),
        // rangePadding: ChartRangePadding.none,
        minimum: minValue * 0.995,
        maximum: maxValue * 1.005,
      ),
      enableAxisAnimation: true,
      // zoomPanBehavior: ZoomPanBehavior(
      //   enablePinching: true,
      //   enablePanning: true,
      // ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(enable: true),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        builder: (data, point, series, pointIndex, seriesIndex) {
          return Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(DateFormat('dd MMM yyyy').format(data.date),
                    style: const TextStyle(color: Colors.white)),
                Text("Shares: ${NumberFormat.compact().format(data.shares)}",
                    style: const TextStyle(color: Colors.white)),
                Text(
                  "Change: ${data.sharesChange}",
                  style: TextStyle(
                    color: data.sharesChange >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      ),

      series: grouped.entries.map((entry) {
        return LineSeries<OwnershipData, DateTime>(
          name: entry.key,
          dataSource: entry.value,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => data.shares,
          width: 2,
          markerSettings: const MarkerSettings(isVisible: true),
        );
      }).toList(),
    );
  }
}
