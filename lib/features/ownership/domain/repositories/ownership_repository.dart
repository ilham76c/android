import '../entities/ownership_entity.dart';

abstract class OwnershipRepository {
  Future<OwnershipEntity> getOwnershipChart(
    String ticker, {
    DateTime? startDate,
    DateTime? endDate,
  });
}