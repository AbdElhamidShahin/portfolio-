import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Skeleton only — no real UI yet.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadHomeProfile(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return switch (state) {
              HomeInitial() || HomeLoading() => const LoadingIndicator(),
              HomeError(message: final msg) =>
                Center(child: Text('Failed to load home: $msg')),
              HomeLoaded() => const Center(child: Text('Home — TODO')),
            };
          },
        ),
      ),
    );
  }
}
