import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../cubit/about_cubit.dart';
import '../cubit/about_state.dart';

/// Skeleton only — no real UI yet.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AboutCubit>()..loadAbout(),
      child: const _AboutView(),
    );
  }
}

class _AboutView extends StatelessWidget {
  const _AboutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AboutCubit, AboutState>(
          builder: (context, state) {
            return switch (state) {
              AboutInitial() || AboutLoading() => const LoadingIndicator(),
              AboutError(message: final msg) =>
                Center(child: Text('Failed to load about: $msg')),
              AboutLoaded() => const Center(child: Text('About — TODO')),
            };
          },
        ),
      ),
    );
  }
}
