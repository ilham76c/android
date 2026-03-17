import '../repositories/ownership_repository.dart';
import '../entities/ownership_entity.dart';

class GetOwnershipChart {
  final OwnershipRepository repository;

  GetOwnershipChart(this.repository);

  Future<OwnershipEntity> call(String ticker) {
    return repository.getOwnershipChart(ticker);
  }
}