import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/service_provider.dart';
import 'data/providers/content_provider.dart';
import 'data/providers/booking_provider.dart';
import 'data/providers/user_preferences_provider.dart';
import 'data/providers/testimonial_provider.dart';

void main() {
  // se inicia la aplicacion envolviendo el widget raiz en providers para inyectar estados
  runApp(
    MultiProvider(
      providers: [
        // provider para gestionar autenticacion de usuario
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // provider para gestionar datos de servicios
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        // provider para gestionar datos de contenido
        ChangeNotifierProvider(create: (_) => ContentProvider()),
        // provider para gestionar reservas de sesiones
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        // provider para gestionar preferencias del usuario
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
        // provider para gestionar testimonios de usuarios
        ChangeNotifierProvider(create: (_) => TestimonialProvider()),
      ],
      // widget principal de la aplicacion
      child: const ESportsCoachApp(),
    ),
  );
}
