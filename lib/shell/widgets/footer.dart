import 'package:flutter/material.dart';

import '../../core/theme/app_breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Static footer shown at the bottom of the single scrollable page.
/// No Cubit dependency — purely presentational, so it's a const
/// StatelessWidget with no rebuild cost.
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = AppBreakpoints.isMobile(width);
    final horizontalPadding = isMobile ? AppSpacing.lg : AppSpacing.huge;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        AppSpacing.xl,
        horizontalPadding,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgElevated,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: isMobile
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FooterBrand(),
                SizedBox(height: AppSpacing.lg),
                _FooterLinks(),
                SizedBox(height: AppSpacing.lg),
                _FooterCopyright(),
              ],
            )
          : const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _FooterBrand(),
                Spacer(),
                _FooterLinks(),
                SizedBox(width: AppSpacing.xl),
                _FooterCopyright(),
              ],
            ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Portfolio',
      style: AppTextStyles.headingLg.copyWith(fontSize: 18),
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: const [
        _FooterLink(label: 'GitHub'),
        _FooterLink(label: 'LinkedIn'),
        _FooterLink(label: 'Email'),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;

  const _FooterLink({required this.label});

  @override
  Widget build(BuildContext context) {
    // Placeholder-only: actual link launching belongs to a future task
    // once a url_launcher-equivalent decision is made; not introduced
    // here without justification per project dependency rules.
    return Text(label, style: AppTextStyles.bodyMd.copyWith(fontSize: 14));
  }
}

class _FooterCopyright extends StatelessWidget {
  const _FooterCopyright();

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    return Text(
      '© $year. Built with Flutter.',
      style: AppTextStyles.caption.copyWith(letterSpacing: 0),
    );
  }
}
