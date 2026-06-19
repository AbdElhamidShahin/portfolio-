import 'package:flutter/material.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_constants.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  setupServiceLocator();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
