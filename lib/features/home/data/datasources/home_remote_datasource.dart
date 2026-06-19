import '../models/home_model.dart';
import '../services/home_service.dart';

/// Thin boundary between the Service (raw IO) and the RepositoryImpl.
/// Lets exceptions from the Service propagate untouched.
abstract class HomeRemoteDataSource {
  Future<HomeModel> fetchHomeProfile();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HomeService _service;

  const HomeRemoteDataSourceImpl(this._service);

  @override
  Future<HomeModel> fetchHomeProfile() {
    return _service.fetchHomeProfile();
  }
}
