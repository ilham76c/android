import '../model/ownership_model.dart';

List<OwnershipData> getMockOwnership() {
  return [
    OwnershipData(
      date: DateTime(2024, 1, 1),
      investor: "Investor A",
      value: 120000000,
      change: 2000000,
    ),
    OwnershipData(
      date: DateTime(2024, 1, 2),
      investor: "Investor A",
      value: 125000000,
      change: 5000000,
    ),
    OwnershipData(
      date: DateTime(2024, 1, 1),
      investor: "Investor B",
      value: 90000000,
      change: -1000000,
    ),
    OwnershipData(
      date: DateTime(2024, 1, 2),
      investor: "Investor B",
      value: 87000000,
      change: -3000000,
    ),
  ];
}
