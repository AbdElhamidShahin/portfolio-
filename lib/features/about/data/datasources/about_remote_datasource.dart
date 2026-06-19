import '../models/about_model.dart';
import '../services/about_service.dart';

abstract class AboutRemoteDataSource {
  Future<AboutModel> fetchAbout();
}

class AboutRemoteDataSourceImpl implements AboutRemoteDataSource {
  final AboutService _service;

  const AboutRemoteDataSourceImpl(this._service);

  @override
  Future<AboutModel> fetchAbout() {
    return _service.fetchAbout();
  }
}
