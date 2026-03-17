class OwnershipEntity {
  final String ticker;
  final List<String> periods;
  final List<OwnershipSeriesEntity> series;

  OwnershipEntity({
    required this.ticker,
    required this.periods,
    required this.series,
  });
}

class OwnershipSeriesEntity {
  final String investor;
  final List<double?> shares;

  OwnershipSeriesEntity({
    required this.investor,
    required this.shares,
  });
}