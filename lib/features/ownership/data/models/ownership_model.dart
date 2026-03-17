import '../../domain/entities/ownership_entity.dart';

class OwnershipModel {
  final String ticker;
  final String name;
  final List<String> periods;
  final String totalShares;
  final List<OwnershipSeriesModel> series;

  OwnershipModel({
    required this.ticker,
    required this.name,
    required this.periods,
    required this.totalShares,
    required this.series,
  });

  factory OwnershipModel.fromJson(Map<String, dynamic> json) {
    return OwnershipModel(
      ticker: json['ticker'],
      name: json['name'],
      periods: List<String>.from(json['periods']),
      totalShares: json['total_shares'],
      series: (json['series'] as List)
          .map((e) => OwnershipSeriesModel.fromJson(e))
          .toList(),
    );
  }
  OwnershipEntity toEntity() {
    return OwnershipEntity(
      ticker: ticker,
      periods: periods,
      series: series.map((e) => e.toEntity()).toList(),
    );
  }
}

class OwnershipSeriesModel {
  final String investor;
  final List<double?> shares;

  OwnershipSeriesModel({
    required this.investor,
    required this.shares,
  });

  factory OwnershipSeriesModel.fromJson(Map<String, dynamic> json) {
    return OwnershipSeriesModel(
      investor: json['investor'],
      shares: (json['shares'] as List)
          .map((e) => e == null ? null : (e as num).toDouble())
          .toList(),
    );
  }

  OwnershipSeriesEntity toEntity() {
    return OwnershipSeriesEntity(
      investor: investor,
      shares: shares,
    );
  }
}