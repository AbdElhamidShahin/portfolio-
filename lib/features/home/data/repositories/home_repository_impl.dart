import '../../../../core/error/api_result.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

/// Owns all error mapping for the Home feature: catches everything the
/// DataSource lets through and converts it into an [ApiResult].
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _dataSource;

  const HomeRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<HomeEntity>> getHomeProfile() async {
    try {
      final model = await _dataSource.fetchHomeProfile();
      return ApiResult.success(model.toEntity());
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }
}
