import '../../domain/entities/ownership_entity.dart';
import '../../domain/repositories/ownership_repository.dart';
import '../datasource/ownership_remote_datasource.dart';

class OwnershipRepositoryImpl implements OwnershipRepository {
  final OwnershipRemoteDataSource remote;

  OwnershipRepositoryImpl(this.remote);

  @override
  Future<OwnershipEntity> getOwnershipChart(String ticker) async {
    final model = await remote.fetchChart(ticker);
    return model.toEntity(); // 🔥 convert ke domain
  }
}