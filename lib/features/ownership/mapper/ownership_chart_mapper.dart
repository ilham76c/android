class OwnershipChartMapper {
  static List<_ChartSeries> map(OwnershipEntity data) {
    return data.series.map((s) {
      return _ChartSeries(
        name: s.investor,
        values: s.shares,
      );
    }).toList();
  }
}

class _ChartSeries {
  final String name;
  final List<double?> values;

  _ChartSeries({required this.name, required this.values});
}