/// The five top-level sections of the single-page portfolio.
/// Shared by the Navbar, the mobile drawer, and [AppShellPage] so every
/// part of the shell refers to the same identifiers — no magic strings.
enum PortfolioSection {
  home('Home'),
  about('About'),
  skills('Skills'),
  projects('Projects'),
  contact('Contact');

  final String label;
  const PortfolioSection(this.label);
}
