import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/home_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Hero section for the single-page portfolio.
///
/// A body-only section meant to be placed inside the App Shell's single
/// Scaffold/scroll view — it does NOT own a Scaffold of its own.
///
/// [onViewWorkTap] and [onContactTap] are optional callbacks the App
/// Shell wires up to its own scroll-to-section logic. HomePage never
/// imports anything from `lib/shell/` — it only knows it can fire a
/// VoidCallback when a CTA is pressed. Defaults are no-ops so this
/// widget still works standalone (e.g. in tests or a storybook).
class HomePage extends StatelessWidget {
  final VoidCallback? onViewWorkTap;
  final VoidCallback? onContactTap;

  const HomePage({
    super.key,
    this.onViewWorkTap,
    this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadHomeProfile(),
      child: _HomeView(
        onViewWorkTap: onViewWorkTap,
        onContactTap: onContactTap,
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  final VoidCallback? onViewWorkTap;
  final VoidCallback? onContactTap;

  const _HomeView({this.onViewWorkTap, this.onContactTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() || HomeLoading() => const LoadingIndicator(),
            HomeError(message: final msg) => _HomeErrorView(
                message: msg,
                onRetry: () => context.read<HomeCubit>().loadHomeProfile(),
              ),
            HomeLoaded(profile: final profile) => _HeroSection(
                profile: profile,
                onViewWorkTap: onViewWorkTap,
                onContactTap: onContactTap,
              ),
          };
        },
      ),
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _HomeErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: AppSpacing.xxl,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Couldn\'t load profile',
              style: AppTextStyles.headingLg.copyWith(fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final HomeEntity profile;
  final VoidCallback? onViewWorkTap;
  final VoidCallback? onContactTap;

  const _HeroSection({
    required this.profile,
    this.onViewWorkTap,
    this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = AppBreakpoints.isMobile(width);
    final isTablet = AppBreakpoints.isTablet(width);
    final isCompact = isMobile || isTablet;
    final horizontalPadding = isMobile
        ? AppSpacing.lg
        : isTablet
            ? AppSpacing.xxl
            : AppSpacing.huge;

    final content = _HeroContent(
      profile: profile,
      isCompact: isCompact,
      onViewWorkTap: onViewWorkTap,
      onContactTap: onContactTap,
    );

    final portrait = _HeroPortrait(avatarUrl: profile.avatarUrl);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isCompact
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: isMobile ? 160 : 200,
                      height: isMobile ? 160 : 200,
                      child: portrait,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    content,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 3, child: content),
                    const SizedBox(width: AppSpacing.xxl),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: SizedBox(
                          width: 320,
                          height: 320,
                          child: portrait,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  final HomeEntity profile;
  final bool isCompact;
  final VoidCallback? onViewWorkTap;
  final VoidCallback? onContactTap;

  const _HeroContent({
    required this.profile,
    required this.isCompact,
    this.onViewWorkTap,
    this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final crossAlign =
        isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = isCompact ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        const _AvailabilityBadge(),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Hi, I\'m ${profile.fullName}',
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.textTertiary,
            fontSize: isCompact ? 16 : 18,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          profile.headline,
          style: AppTextStyles.responsiveDisplay(
            MediaQuery.sizeOf(context).width,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: AppSpacing.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            profile.tagline,
            style: AppTextStyles.bodyLg,
            textAlign: textAlign,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _CtaRow(
          isCompact: isCompact,
          onViewWorkTap: onViewWorkTap,
          onContactTap: onContactTap,
        ),
      ],
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.tagBg,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.tagBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'AVAILABLE FOR WORK',
            style: AppTextStyles.caption.copyWith(color: AppColors.tagText),
          ),
        ],
      ),
    );
  }
}

class _CtaRow extends StatelessWidget {
  final bool isCompact;
  final VoidCallback? onViewWorkTap;
  final VoidCallback? onContactTap;

  const _CtaRow({
    required this.isCompact,
    this.onViewWorkTap,
    this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _PrimaryCtaButton(label: 'View My Work', onTap: onViewWorkTap),
      _SecondaryCtaButton(label: 'Contact Me', onTap: onContactTap),
    ];

    if (isCompact) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: double.infinity, child: buttons[0]),
          const SizedBox(height: AppSpacing.md),
          SizedBox(width: double.infinity, child: buttons[1]),
        ],
      );
    }

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: buttons,
    );
  }
}

class _PrimaryCtaButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const _PrimaryCtaButton({required this.label, this.onTap});

  @override
  State<_PrimaryCtaButton> createState() => _PrimaryCtaButtonState();
}

class _PrimaryCtaButtonState extends State<_PrimaryCtaButton> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppDurations.base,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            gradient: AppColors.gradientBrand,
            borderRadius: AppRadius.button,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary500.withOpacity(0.45),
                      blurRadius: 28,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.primary500.withOpacity(0.25),
                      blurRadius: 16,
                    ),
                  ],
          ),
          transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryCtaButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const _SecondaryCtaButton({required this.label, this.onTap});

  @override
  State<_SecondaryCtaButton> createState() => _SecondaryCtaButtonState();
}

class _SecondaryCtaButtonState extends State<_SecondaryCtaButton> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppDurations.base,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.bgSurfaceHover : Colors.transparent,
            borderRadius: AppRadius.button,
            border: Border.all(
              color: _isHovered
                  ? AppColors.borderStrong
                  : AppColors.borderDefault,
            ),
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroPortrait extends StatelessWidget {
  final String avatarUrl;

  const _HeroPortrait({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.gradientBrand,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary500.withOpacity(0.35),
            blurRadius: 48,
            spreadRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xxs),
      child: ClipOval(
        child: ColoredBox(
          color: AppColors.bgSurface,
          child: avatarUrl.startsWith('http')
              ? Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const _AvatarFallback(),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const _AvatarFallback();
                  },
                )
              : const _AvatarFallback(),
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.person_rounded,
        color: AppColors.textTertiary,
        size: AppSpacing.xxxl,
      ),
    );
  }
}
