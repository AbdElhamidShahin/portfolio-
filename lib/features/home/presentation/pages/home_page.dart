import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
/// A body-only section — never owns a Scaffold of its own.
/// [onViewWorkTap] and [onContactTap] are VoidCallbacks wired by the App Shell.
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
            const Icon(Icons.error_outline,
                color: AppColors.error, size: AppSpacing.xxl),
            const SizedBox(height: AppSpacing.md),
            Text('Couldn\'t load profile',
                style: AppTextStyles.headingLg.copyWith(fontSize: 18)),
            const SizedBox(height: AppSpacing.xs),
            Text(message,
                style: AppTextStyles.bodyMd, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

// ─── Hero section ─────────────────────────────────────────────────────────────

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
        ? AppSpacing.xxs
        : isTablet
            ? AppSpacing.xxs
            : AppSpacing.xxs;

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
                  // Was CrossAxisAlignment.center — that centered the
                  // portrait against the FULL height of `content`
                  // (badge + greeting + headline + tagline + CTAs +
                  // quick-contact icons), which is much taller than the
                  // portrait itself. That pushed the portrait's visual
                  // center down to roughly the CTA row instead of the
                  // headline. Switching to `start` + Align(topCenter)
                  // below lets us control the portrait's position
                  // explicitly instead of having it centered against
                  // a column it has no relation to.
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Padding(
                        // Nudges the text block down slightly so it
                        // meets the portrait roughly at the same level.
                        padding: const EdgeInsets.only(top: AppSpacing.xl),
                        child: content,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxl),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          // Small breathing room above the portrait so
                          // it doesn't sit flush at the very top edge.
                          padding: const EdgeInsets.only(top: AppSpacing.md),
                          child: SizedBox(
                            width: 320,
                            height: 320,
                            child: portrait,
                          ),
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

// ─── Hero content (text + CTA + quick links) ──────────────────────────────────

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
          style:
              AppTextStyles.responsiveDisplay(MediaQuery.sizeOf(context).width),
          textAlign: textAlign,
        ),
        const SizedBox(height: AppSpacing.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(profile.tagline,
              style: AppTextStyles.bodyLg, textAlign: textAlign),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _CtaRow(
          profile: profile,
          isCompact: isCompact,
          onViewWorkTap: onViewWorkTap,
          onContactTap: onContactTap,
        ),
        const SizedBox(height: AppSpacing.xl),
        _QuickContactRow(profile: profile, isCompact: isCompact),
      ],
    );
  }
}

// ─── CTA row (View Work · Contact Me · Download CV) ──────────────────────────

class _CtaRow extends StatelessWidget {
  final HomeEntity profile;
  final bool isCompact;
  final VoidCallback? onViewWorkTap;
  final VoidCallback? onContactTap;

  const _CtaRow({
    required this.profile,
    required this.isCompact,
    this.onViewWorkTap,
    this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _PrimaryCtaButton(label: 'View My Work', onTap: onViewWorkTap),
      _SecondaryCtaButton(label: 'Contact Me', onTap: onContactTap),
      _DownloadCvButton(cvAssetPath: profile.cvAssetPath),
    ];

    if (isCompact) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: double.infinity, child: buttons[0]),
          const SizedBox(height: AppSpacing.md),
          Row(children: [
            Expanded(child: buttons[1]),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: buttons[2]),
          ]),
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

// ─── Quick-contact icon row (WhatsApp · GitHub · LinkedIn · Gmail) ────────────

class _QuickContactRow extends StatelessWidget {
  final HomeEntity profile;
  final bool isCompact;

  const _QuickContactRow({required this.profile, required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isCompact ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        _QuickContactButton(
          tooltip: 'WhatsApp',
          iconColor: const Color(0xFF25D366),
          backgroundColor: const Color(0xFF25D366).withOpacity(0.12),
          url: profile.whatsappUrl,
          child: const Icon(Icons.chat_rounded,
              size: 18, color: Color(0xFF25D366)),
        ),
        const SizedBox(width: AppSpacing.sm),
        _QuickContactButton(
          tooltip: 'GitHub',
          iconColor: AppColors.textSecondary,
          backgroundColor: AppColors.bgSurface,
          url: profile.githubUrl,
          child: const Icon(Icons.code_rounded,
              size: 18, color: AppColors.textSecondary),
        ),
        const SizedBox(width: AppSpacing.sm),
        _QuickContactButton(
          tooltip: 'LinkedIn',
          iconColor: const Color(0xFF0A66C2),
          backgroundColor: const Color(0xFF0A66C2).withOpacity(0.12),
          url: profile.linkedInUrl,
          child: const Icon(Icons.work_outline_rounded,
              size: 18, color: Color(0xFF0A66C2)),
        ),
        const SizedBox(width: AppSpacing.sm),
        _QuickContactButton(
          tooltip: 'Send Email',
          iconColor: AppColors.error,
          backgroundColor: AppColors.error.withOpacity(0.10),
          url: profile.gmailUrl,
          child: const Icon(Icons.email_outlined,
              size: 18, color: AppColors.error),
        ),
      ],
    );
  }
}

class _QuickContactButton extends StatefulWidget {
  final String tooltip;
  final Color iconColor;
  final Color backgroundColor;
  final String url;
  final Widget child;

  const _QuickContactButton({
    required this.tooltip,
    required this.iconColor,
    required this.backgroundColor,
    required this.url,
    required this.child,
  });

  @override
  State<_QuickContactButton> createState() => _QuickContactButtonState();
}

class _QuickContactButtonState extends State<_QuickContactButton> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: GestureDetector(
          onTap: _launch,
          child: AnimatedContainer(
            duration: AppDurations.fast,
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isHovered ? widget.backgroundColor : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: _isHovered
                    ? widget.iconColor.withOpacity(0.4)
                    : AppColors.borderSubtle,
              ),
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}

// ─── Download CV button ───────────────────────────────────────────────────────

class _DownloadCvButton extends StatefulWidget {
  final String cvAssetPath;

  const _DownloadCvButton({required this.cvAssetPath});

  @override
  State<_DownloadCvButton> createState() => _DownloadCvButtonState();
}

class _DownloadCvButtonState extends State<_DownloadCvButton> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  Future<void> _download() async {
    // On Flutter Web: open the asset URL in a new tab so the browser
    // triggers a native download. On other platforms, launch via url_launcher.
    final uri = Uri.parse(widget.cvAssetPath);
    if (kIsWeb) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (await canLaunchUrl(uri)) await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: _download,
        child: AnimatedContainer(
          duration: AppDurations.base,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.bgSurfaceHover : Colors.transparent,
            borderRadius: AppRadius.button,
            border: Border.all(
              color:
                  _isHovered ? AppColors.borderStrong : AppColors.borderDefault,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.download_rounded,
                size: 16,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Download CV',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Availability badge ───────────────────────────────────────────────────────

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

// ─── Portrait ─────────────────────────────────────────────────────────────────

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
                  errorBuilder: (_, __, ___) => const _AvatarFallback(),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return const _AvatarFallback();
                  },
                )
              : Image.asset(
                  avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _AvatarFallback(),
                ),
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

// ─── Primary CTA ──────────────────────────────────────────────────────────────

class _PrimaryCtaButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const _PrimaryCtaButton({required this.label, this.onTap});

  @override
  State<_PrimaryCtaButton> createState() => _PrimaryCtaButtonState();
}

class _PrimaryCtaButtonState extends State<_PrimaryCtaButton> {
  bool _isHovered = false;

  void _setHovered(bool v) {
    if (_isHovered == v) return;
    setState(() => _isHovered = v);
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
              horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            gradient: AppColors.gradientBrand,
            borderRadius: AppRadius.button,
            boxShadow: [
              BoxShadow(
                color:
                    AppColors.primary500.withOpacity(_isHovered ? 0.45 : 0.25),
                blurRadius: _isHovered ? 28 : 16,
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

// ─── Secondary CTA ────────────────────────────────────────────────────────────

class _SecondaryCtaButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const _SecondaryCtaButton({required this.label, this.onTap});

  @override
  State<_SecondaryCtaButton> createState() => _SecondaryCtaButtonState();
}

class _SecondaryCtaButtonState extends State<_SecondaryCtaButton> {
  bool _isHovered = false;

  void _setHovered(bool v) {
    if (_isHovered == v) return;
    setState(() => _isHovered = v);
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
              horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.bgSurfaceHover : Colors.transparent,
            borderRadius: AppRadius.button,
            border: Border.all(
              color:
                  _isHovered ? AppColors.borderStrong : AppColors.borderDefault,
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
