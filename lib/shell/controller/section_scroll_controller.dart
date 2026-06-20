import 'package:flutter/widgets.dart';

import 'portfolio_section.dart';

/// Owns one [GlobalKey] per [PortfolioSection] and knows how to scroll
/// the page so that section comes into view.
///
/// This is plain Dart/Flutter widget-layer plumbing — not business logic
/// — so it lives in the shell, not in any feature's domain or data layer.
/// Created once per [AppShellPage] and disposed with it; never recreated
/// inside a build() method.
class SectionScrollController {
  final Map<PortfolioSection, GlobalKey> _sectionKeys = {
    for (final section in PortfolioSection.values) section: GlobalKey(),
  };

  GlobalKey keyFor(PortfolioSection section) => _sectionKeys[section]!;

  Future<void> scrollToSection(PortfolioSection section) async {
    final context = _sectionKeys[section]?.currentContext;
    if (context == null) return;

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }
}
