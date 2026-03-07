class OwnershipChartResponse {
  final String ticker;
  final double totalShares;
  final List<DateTime> periods;
  final List<OwnershipSeries> series;

  OwnershipChartResponse({
    required this.ticker,
    required this.totalShares,
    required this.periods,
    required this.series,
  });

  factory OwnershipChartResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return OwnershipChartResponse(
      ticker: data["ticker"],
      totalShares: double.parse(data["total_shares"]),
      periods: (data["periods"] as List)
          .map((e) => DateTime.parse(e))
          .toList(),
      series: (data["series"] as List)
          .map((e) => OwnershipSeries.fromJson(e))
          .toList(),
    );
  }
}

class OwnershipSeries {
  final String investor;
  final List<double> shares;

  OwnershipSeries({
    required this.investor,
    required this.shares,
  });

  factory OwnershipSeries.fromJson(Map<String, dynamic> json) {
    return OwnershipSeries(
      investor: json["investor"],
      shares: (json["shares"] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}

class OwnershipChartPoint {
  final DateTime date;
  final double shares;
  final double percent;
  final String investor;

  OwnershipChartPoint({
    required this.date,
    required this.shares,
    required this.percent,
    required this.investor,
  });
}