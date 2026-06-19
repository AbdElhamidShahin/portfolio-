import '../../../../core/error/api_result.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/about_entity.dart';
import '../../domain/repositories/about_repository.dart';
import '../datasources/about_remote_datasource.dart';

class AboutRepositoryImpl implements AboutRepository {
  final AboutRemoteDataSource _dataSource;

  const AboutRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<AboutEntity>> getAbout() async {
    try {
      final model = await _dataSource.fetchAbout();
      return ApiResult.success(model.toEntity());
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }
}
