import 'package:get_it/get_it.dart';

/// The single GetIt instance used across the app.
/// Feature `*_injection.dart` files register their dependencies on this
/// instance; `injection_container.dart` is what actually calls them.
final getIt = GetIt.instance;
