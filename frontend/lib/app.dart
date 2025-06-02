import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/themes.dart';
import 'data/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';

class ESportsCoachApp extends StatelessWidget {
  const ESportsCoachApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eSports Coach', // titulo de la aplicacion
      debugShowCheckedModeBanner: false, // oculta banner de debug en esquina
      theme: AppThemes.lightTheme, // tema claro definido en config/themes.dart
      darkTheme: AppThemes.darkTheme, // tema oscuro definido en config/themes.dart
      themeMode: ThemeMode.system, // usa tema segun configuracion del sistema
      onGenerateRoute: AppRoutes.generateRoute, // maneja rutas dinamicas con AppRoutes
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // si el estado aun es inicial, se muestra indicador de carga
          if (authProvider.status == AuthStatus.initial) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // spinner mientras verifica auth
              ),
            );
          }

          // si el usuario esta autenticado, redirige a HomeScreen
          if (authProvider.isAuthenticated) {
            return const HomeScreen();
          } 
          
          // si no esta autenticado, muestra LoginScreen
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
