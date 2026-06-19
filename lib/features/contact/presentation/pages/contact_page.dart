import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../cubit/contact_cubit.dart';
import '../cubit/contact_state.dart';

/// Skeleton only — no real UI yet.
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ContactCubit>()..loadContactInfo(),
      child: const _ContactView(),
    );
  }
}

class _ContactView extends StatelessWidget {
  const _ContactView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ContactCubit, ContactState>(
          builder: (context, state) {
            return switch (state) {
              ContactInitial() || ContactLoading() => const LoadingIndicator(),
              ContactError(message: final msg) =>
                Center(child: Text('Failed to load contact info: $msg')),
              ContactLoaded() => const Center(child: Text('Contact — TODO')),
              ContactMessageSending() => const LoadingIndicator(),
              ContactMessageSent() =>
                const Center(child: Text('Message sent — TODO')),
              ContactMessageError(message: final msg) =>
                Center(child: Text('Failed to send message: $msg')),
            };
          },
        ),
      ),
    );
  }
}
