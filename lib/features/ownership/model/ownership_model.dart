class OwnershipData {
  final DateTime date;
  final String investor;
  final String investorType;
  final double shares;
  final double sharesChange;
  final double cumulativeChange;

  OwnershipData({
    required this.date,
    required this.investor,
    required this.investorType,
    required this.shares,
    required this.sharesChange,
    required this.cumulativeChange,
  });

  factory OwnershipData.fromJson(Map<String, dynamic> json) {
    return OwnershipData(
      date: DateTime.parse(json['ownership_date']),
      investor: _normalizeInvestor(json['investor_name']),
      investorType: json['investor_type'] ?? '',
      shares: (json['shares'] ?? 0).toDouble(),
      sharesChange: (json['shares_change'] ?? 0).toDouble(),
      cumulativeChange:
          (json['cumulative_shares_change'] ?? 0).toDouble(),
    );
  }

  // 🔥 Normalisasi nama supaya tidak dobel di chart
  static String _normalizeInvestor(String name) {
    return name.replaceAll('.', '').trim().toUpperCase();
  }
}
