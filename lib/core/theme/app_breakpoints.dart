class AppBreakpoints {
  AppBreakpoints._();
  static const double mobile = 640;
  static const double tablet = 1024;
  static const double laptop = 1440;

  static bool isMobile(double w) => w < mobile;
  static bool isTablet(double w) => w >= mobile && w < tablet;
  static bool isLaptop(double w) => w >= tablet && w < laptop;
  static bool isDesktop(double w) => w >= laptop;
}