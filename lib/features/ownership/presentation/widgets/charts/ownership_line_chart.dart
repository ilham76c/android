import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../domain/entities/ownership_entity.dart';

class OwnershipLineChart extends StatelessWidget {
  final OwnershipEntity data;

  const OwnershipLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,

        // ======================
        // LEGEND (scrollable vertical)
        // ======================
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.scroll,
          position: LegendPosition.top,
          textStyle: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 12,
          ),
        ),

        // ======================
        // TOOLTIP
        // ======================
        tooltipBehavior: TooltipBehavior(
          enable: true,
          shared: true, // 🔥 ini penting (multi-series seperti ECharts)
          builder: (dynamic dataPoint, dynamic point, dynamic series,
              int pointIndex, int seriesIndex) {
            return _buildTooltip(pointIndex);
          },
        ),

        // ======================
        // X AXIS
        // ======================
        primaryXAxis: CategoryAxis(
          labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          axisLine: const AxisLine(color: Color(0xFF374151)),
        ),

        // ======================
        // Y AXIS (formatter)
        // ======================
        primaryYAxis: NumericAxis(
          labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          numberFormat: null,
          axisLabelFormatter: (AxisLabelRenderDetails args) {
            return ChartAxisLabel(
              _formatNumber(args.value),
              const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10),
            );
          },
          minimum: _getMinY() * 0.95,
          maximum: _getMaxY() * 1.05,
        ),

        // ======================
        // SERIES
        // ======================
        series: _buildSeries(),
      ),
    );
  }

  // ======================
  // SERIES
  // ======================
  List<LineSeries<_ChartPoint, String>> _buildSeries() {
    return data.series.map((s) {
      final chartData = <_ChartPoint>[];

      for (int i = 0; i < data.periods.length; i++) {
        chartData.add(
          _ChartPoint(
            data.periods[i],
            s.shares[i],
            i,
          ),
        );
      }

      return LineSeries<_ChartPoint, String>(
        name: s.investor,
        dataSource: chartData,
        xValueMapper: (p, _) => p.period,
        yValueMapper: (p, _) => p.value ?? 0,
        markerSettings: const MarkerSettings(
          isVisible: true,
          width: 4,
          height: 4,
        ),
        width: 2,
      );
    }).toList();
  }

  // ======================
  // TOOLTIP BUILDER
  // ======================
  Widget _buildTooltip(int dataIndex) {
    String title = data.periods[dataIndex];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),

          ...data.series.map((s) {
            final current = s.shares[dataIndex] ?? 0;
            final prev =
                dataIndex > 0 ? (s.shares[dataIndex - 1] ?? 0) : 0;

            final change = current - prev;

            Color color = Colors.grey;
            if (change > 0) color = Colors.green;
            if (change < 0) color = Colors.red;

            final changeText = dataIndex == 0
                ? ''
                : ' (${change > 0 ? '+' : ''}${current.toStringAsFixed(0)})';

            return Text(
              '${s.investor}: ${current.toStringAsFixed(0)}$changeText',
              style: TextStyle(color: color, fontSize: 12),
            );
          }),
        ],
      ),
    );
  }

  // ======================
  // FORMAT NUMBER (K/M/B)
  // ======================
  String _formatNumber(num value) {
    final abs = value.abs();

    if (abs >= 1e9) return '${(value / 1e9).toStringAsFixed(1)}B';
    if (abs >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
    if (abs >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';

    return value.toStringAsFixed(0);
  }

  double _getMinY() {
    final values = data.series
        .expand((s) => s.shares)
        .whereType<double>();
    return values.reduce((a, b) => a < b ? a : b);
  }

  double _getMaxY() {
    final values = data.series
        .expand((s) => s.shares)
        .whereType<double>();
    return values.reduce((a, b) => a > b ? a : b);
  }
}

// ======================
// INTERNAL MODEL
// ======================
class _ChartPoint {
  final String period;
  final double? value;
  final int index;

  _ChartPoint(this.period, this.value, this.index);
}