import '../../domain/entities/ownership_entity.dart';
import '../../domain/repositories/ownership_repository.dart';
import '../datasource/ownership_remote_datasource.dart';

class OwnershipRepositoryImpl implements OwnershipRepository {
  final OwnershipRemoteDataSource remote;

  OwnershipRepositoryImpl(this.remote);

  @override
  Future<OwnershipEntity> getOwnershipChart(
    String ticker, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final model = await remote.fetchChart(
      ticker,
      startDate: startDate,
      endDate: endDate,
    );

    return model.toEntity();
  }
}