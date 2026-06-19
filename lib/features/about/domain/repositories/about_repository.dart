import '../../../../core/error/api_result.dart';
import '../entities/about_entity.dart';

abstract class AboutRepository {
  Future<ApiResult<AboutEntity>> getAbout();
}
