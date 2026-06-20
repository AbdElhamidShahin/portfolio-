import '../models/home_model.dart';


class HomeService {
  Future<HomeModel> fetchHomeProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const HomeModel(
      fullName: 'Abdelhamid Shahin',
      headline: 'Junior Flutter Developer',
      tagline: 'I engineer clean, scalable mobile and web apps with Flutter — '
          'built on Clean Architecture, tuned for performance, and designed '
          'to grow without breaking.',
      avatarUrl: 'assets/images/home/avatar.jpeg',
      cvAssetPath: 'assets/cv/abdelhamid_shahin_cv.pdf',
      // Replace the number with your real WhatsApp number (international, no +)
      whatsappUrl: 'https://wa.me/201205687372',
      githubUrl: 'https://github.com/AbdElhamidShahin',
      linkedInUrl: 'https://www.linkedin.com/in/abd-el-hamid-shahin-7a035b268/',
      gmailUrl: 'mailto:abdelhamid.shahin0@gmail.com',
    );
  }
}
