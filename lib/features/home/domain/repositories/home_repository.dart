import '../../../../core/error/api_result.dart';
import '../entities/home_entity.dart';

/// Abstract contract. Pure Dart — the domain layer never knows how
/// this is fulfilled (mock, REST, local JSON, etc).
abstract class HomeRepository {
  Future<ApiResult<HomeEntity>> getHomeProfile();
}
