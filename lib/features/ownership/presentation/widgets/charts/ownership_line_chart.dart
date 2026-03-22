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
    return widget.data.series.map((s) {
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
        width: 2,
        markerSettings: const MarkerSettings(
          isVisible: true,
          width: 6,
          height: 6,
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
            backgroundColor: Colors.transparent,

            crosshairBehavior: CrosshairBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineType: CrosshairLineType.vertical,
              lineDashArray: const [5, 5],
            ),

            tooltipBehavior: TooltipBehavior(
              enable: true,
              shared: true,
              color: Colors.transparent,
              elevation: 0,
              builder: (data, point, series, pointIndex, seriesIndex) {
                return _buildTooltip(pointIndex);
              },
            ),

            primaryXAxis: const CategoryAxis(
              labelRotation: -45,
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(
                color: Color(0xFF374151),
              ),
            ),

            primaryYAxis: NumericAxis(
              isVisible: true,
              rangePadding: ChartRangePadding.none,
              majorGridLines: const MajorGridLines(
                width: 1,
                dashArray: [4, 4],
                color: Color(0xFF374151),
              ),
              axisLabelFormatter: (args) {
                final value = args.value.toDouble();

                if (value.abs() >= 1e9) {
                  return ChartAxisLabel(
                    '${(value / 1e9).toStringAsFixed(1)}B',
                    const TextStyle(color: Color(0xFF9CA3AF)),
                  );
                }

                if (value.abs() >= 1e6) {
                  return ChartAxisLabel(
                    '${(value / 1e6).toStringAsFixed(1)}M',
                    const TextStyle(color: Color(0xFF9CA3AF)),
                  );
                }

                if (value.abs() >= 1e3) {
                  return ChartAxisLabel(
                    '${(value / 1e3).toStringAsFixed(1)}K',
                    const TextStyle(color: Color(0xFF9CA3AF)),
                  );
                }

                return ChartAxisLabel(
                  value.toStringAsFixed(0),
                  const TextStyle(color: Color(0xFF9CA3AF)),
                );
              },
            ),

            series: _buildSeries(),
          ),
        ),

        // Container(
        //   decoration: BoxDecoration(
        //     color: const Color(0xFF111827),
        //     borderRadius: BorderRadius.circular(12),
        //     border: Border.all(color: const Color(0xFF1F2937)),
        //   ),
        //   padding: const EdgeInsets.all(12),
        //   child: SfCartesianChart(
        //     backgroundColor: Colors.transparent,

        //     crosshairBehavior: CrosshairBehavior(
        //       enable: true,
        //       activationMode: ActivationMode.singleTap,
        //       lineType: CrosshairLineType.vertical,
        //       lineDashArray: const [5, 5],
        //     ),

        //     tooltipBehavior: TooltipBehavior(
        //       enable: true,
        //       shared: true,
        //       color: Colors.transparent,
        //       elevation: 0,
        //       builder: (data, point, series, pointIndex, seriesIndex) {
        //         return _buildTooltip(pointIndex);
        //       },
        //     ),

        //     primaryXAxis: CategoryAxis(
        //       labelRotation: -45,
        //       majorGridLines: const MajorGridLines(width: 0),
        //       axisLine: const AxisLine(
        //         color: Color(0xFF374151),
        //       ),
        //     ),

        //     primaryYAxis: NumericAxis(
        //       isVisible: true,
        //       majorGridLines: const MajorGridLines(
        //         width: 1,
        //         dashArray: [4, 4],
        //         color: Color(0xFF374151),
        //       ),
        //       axisLabelFormatter: (args) {
        //         final value = double.tryParse(args.text) ?? 0;

        //         if (value.abs() >= 1e9) {
        //           return ChartAxisLabel('${(value / 1e9).toStringAsFixed(1)}B', const TextStyle(color: Color(0xFF9CA3AF)));
        //         }
        //         if (value.abs() >= 1e6) {
        //           return ChartAxisLabel('${(value / 1e6).toStringAsFixed(1)}M', const TextStyle(color: Color(0xFF9CA3AF)));
        //         }
        //         if (value.abs() >= 1e3) {
        //           return ChartAxisLabel('${(value / 1e3).toStringAsFixed(1)}K', const TextStyle(color: Color(0xFF9CA3AF)));
        //         }

        //         return ChartAxisLabel(value.toStringAsFixed(0), const TextStyle(color: Color(0xFF9CA3AF)));
        //       },
        //     ),

        //     series: _buildSeries(),
        //   ),
        // )
      ],
    );
  }

  Widget _buildTooltip(int index) {
    final period = widget.data.periods[index];

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔥 TITLE
          Text(
            period,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          // 🔥 SERIES LOOP
          ...widget.data.series.map((s) {
            final current = s.shares[index] ?? 0;
            final prev =
                index > 0 ? (s.shares[index - 1] ?? 0) : 0;

            final change = current - prev;

            Color color = const Color(0xFF9CA3AF);
            if (change > 0) color = const Color(0xFF22C55E);
            if (change < 0) color = const Color(0xFFEF4444);

            final changeText = index == 0
                ? ''
                : ' (${change > 0 ? '+' : ''}${_formatNumber(change)})';

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 6, top: 4),
                    decoration: BoxDecoration(
                      color: _getColor(s.investor),
                      shape: BoxShape.circle,
                    ),
                  ),

                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${s.investor}: ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                          TextSpan(
                            text: _formatNumber(current),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                          TextSpan(
                            text: changeText,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatNumber(num value) {
    if (value.abs() >= 1e9) return '${(value / 1e9).toStringAsFixed(1)}B';
    if (value.abs() >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
    if (value.abs() >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
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