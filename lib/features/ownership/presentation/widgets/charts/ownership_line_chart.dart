import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../domain/entities/ownership_entity.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../domain/entities/ownership_entity.dart';

class OwnershipLineChart extends StatefulWidget {
  final OwnershipEntity data;

  const OwnershipLineChart({super.key, required this.data});

  @override
  State<OwnershipLineChart> createState() =>
      _OwnershipLineChartState();
}

class _OwnershipLineChartState extends State<OwnershipLineChart> {

  late Set<String> _activeInvestors;

  @override
  void initState() {
    super.initState();

    _activeInvestors = widget.data.series
        .map((s) => s.investor)
        .toSet();
  }

  // ======================
  // TOGGLE LEGEND
  // ======================
  void _toggleInvestor(String name) {
    setState(() {
      if (_activeInvestors.contains(name)) {
        _activeInvestors.remove(name);
      } else {
        _activeInvestors.add(name);
      }
    });
  }

  // ======================
  // BUILD CHART SERIES
  // ======================
  List<LineSeries<_ChartPoint, String>> _buildSeries() {
    return widget.data.series
        .where((s) => _activeInvestors.contains(s.investor))
        .map((s) {
      final chartData = <_ChartPoint>[];

      for (int i = 0; i < widget.data.periods.length; i++) {
        chartData.add(
          _ChartPoint(
            widget.data.periods[i],
            s.shares[i],
          ),
        );
      }

      return LineSeries<_ChartPoint, String>(
        name: s.investor,
        dataSource: chartData,
        xValueMapper: (p, _) => p.period,
        yValueMapper: (p, _) => p.value ?? 0,
        width: 3,
        markerSettings: const MarkerSettings(
          isVisible: true,
          width: 4,
          height: 4,
        ),
      );
    }).toList();
  }

  // ======================
  // CUSTOM LEGEND
  // ======================
  Widget _buildLegend() {
    return Column(
      children: widget.data.series.map((s) {
        final isActive = _activeInvestors.contains(s.investor);

        return GestureDetector(
          onTap: () => _toggleInvestor(s.investor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: isActive
                      ? _getColor(s.investor)
                      : Colors.grey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    s.investor,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? Colors.white : Colors.grey,
                      decoration: isActive
                          ? null
                          : TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ======================
  // Y AXIS SCALE FIX
  // ======================
  double _getMinY() {
    final values = widget.data.series
        .expand((s) => s.shares)
        .whereType<double>()
        .toList();

    if (values.isEmpty) return 0;

    return values.reduce((a, b) => a < b ? a : b);
  }

  double _getMaxY() {
    final values = widget.data.series
        .expand((s) => s.shares)
        .whereType<double>()
        .toList();

    if (values.isEmpty) return 0;

    return values.reduce((a, b) => a > b ? a : b);
  }

  // ======================
  // COLOR GENERATOR
  // ======================
  Color _getColor(String key) {
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.cyan,
      Colors.amber,
    ];

    return colors[key.hashCode % colors.length];
  }

  // ======================
  // BUILD
  // ======================
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔥 LEGEND (auto height)
        _buildLegend(),

        const SizedBox(height: 8),

        // 🔥 CHART (ambil sisa space)
        Expanded(
          child: SfCartesianChart(
            legend: Legend(isVisible: false),

            primaryXAxis: CategoryAxis(
              labelRotation: -30, // 🔥 miring 45 derajat
              labelStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 10,
              ),
            ),

            primaryYAxis: NumericAxis(
              minimum: _getMinY() * 0.95,
              maximum: _getMaxY() * 1.05,
              labelStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 10,
              ),
            ),

            tooltipBehavior: TooltipBehavior(
              enable: true,
              shared: true, // 🔥 penting (multi-series)
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {

                return _buildTooltip(pointIndex);
              },
            ),

            series: _buildSeries(),
          ),
        ),
      ],
    );
  }

  Widget _buildTooltip(int dataIndex) {
    final period = widget.data.periods[dataIndex];

    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 🔥 AUTO HEIGHT
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              period,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            ...widget.data.series.map((s) {
              final current = s.shares[dataIndex] ?? 0;
              final prev =
                  dataIndex > 0 ? (s.shares[dataIndex - 1] ?? 0) : 0;

              final change = current - prev;

              Color color = Colors.grey;
              if (change > 0) color = Colors.green;
              if (change < 0) color = Colors.red;

              final changeText = dataIndex == 0
                  ? ''
                  : ' (${change > 0 ? '+' : ''}${_formatNumber(change)})';

              return Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6, top: 4),
                      color: _getColor(s.investor),
                    ),

                    Expanded(
                      child: Text(
                        '${s.investor}: ${_formatNumber(current)}$changeText',
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true, // 🔥 penting
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _formatNumber(num value) {
    final abs = value.abs();

    if (abs >= 1e9) return '${(value / 1e9).toStringAsFixed(1)}B';
    if (abs >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
    if (abs >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';

    return value.toStringAsFixed(0);
  }
}

// ======================
// INTERNAL MODEL
// ======================
class _ChartPoint {
  final String period;
  final double? value;

  _ChartPoint(this.period, this.value);
}