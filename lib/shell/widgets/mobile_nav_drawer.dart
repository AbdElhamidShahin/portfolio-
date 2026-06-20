import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../controller/portfolio_section.dart';

/// Mobile-only navigation drawer shown when the Navbar's menu button is
/// tapped below [AppBreakpoints.mobile]. Closes itself before invoking
/// [onSectionTap] so the scroll animation isn't fighting the drawer's
/// own close animation.
class MobileNavDrawer extends StatelessWidget {
  final PortfolioSection? activeSection;
  final ValueChanged<PortfolioSection> onSectionTap;

  const MobileNavDrawer({
    super.key,
    required this.activeSection,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bgElevated,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Menu', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.lg),
              for (final section in PortfolioSection.values)
                _DrawerLink(
                  section: section,
                  isActive: section == activeSection,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSectionTap(section);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerLink extends StatelessWidget {
  final PortfolioSection section;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerLink({
    required this.section,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.button,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Text(
            section.label,
            style: AppTextStyles.bodyLg.copyWith(
              fontSize: 18,
              color: isActive
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
