import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/about/screens/about_screen.dart';
import '../features/services/screens/services_screen.dart';
import '../features/content/screens/content_screen.dart';
import '../features/testimonials/screens/testimonials_screen.dart';
import '../features/contact/screens/contact_screen.dart';
import '../features/members/screens/members_screen.dart';
import '../features/members/screens/profile_screen.dart';
import '../features/members/screens/bookings_screen.dart';
import '../features/members/screens/premium_content_screen.dart';

/*
  clase que define las rutas de la aplicacion:
  - constantes con nombres de rutas
  - metodo generateRoute para devolver la pantalla correspondiente segun el nombre de ruta
*/
class AppRoutes {
  /*
    constantes que representan cada ruta disponible en la aplicacion
  */
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String about = '/about';
  static const String services = '/services';
  static const String content = '/content';
  static const String testimonials = '/testimonials';
  static const String contact = '/contact';
  static const String members = '/members';
  static const String profile = '/profile';
  static const String bookings = '/bookings';
  static const String premiumContent = '/premium-content';

  /*
    metodo que genera la ruta apropiada segun RouteSettings:
    - usa switch para mapear cada nombre de ruta a su pantalla correspondiente
    - en caso de ruta no definida, muestra pantalla con mensaje de error
  */
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      case services:
        return MaterialPageRoute(builder: (_) => const ServicesScreen());
      case content:
        return MaterialPageRoute(builder: (_) => const ContentScreen());
      case testimonials:
        return MaterialPageRoute(builder: (_) => const TestimonialsScreen());
      case contact:
        return MaterialPageRoute(builder: (_) => const ContactScreen());
      case members:
        return MaterialPageRoute(builder: (_) => const MembersScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case bookings:
        return MaterialPageRoute(builder: (_) => const BookingsScreen());
      case premiumContent:
        return MaterialPageRoute(builder: (_) => PremiumContentScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('no route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
