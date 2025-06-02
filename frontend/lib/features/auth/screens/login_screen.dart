import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../data/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  // clave para el formulario y controladores de texto para email y password
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // control para animacion de desvanecimiento al mostrar la pantalla
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // inicializacion del controller de animacion con duracion de 800ms
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    // definicion de animacion de tween para interpolar opacidad de 0 a 1
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // iniciar animacion al construir el widget
    _animationController.forward();
  }

  @override
  void dispose() {
    // liberar recursos de controladores y animacion
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // alterna visibilidad del texto de la contraseña
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // metodo que ejecuta el proceso de login usando el provider
  Future<void> _login() async {
    // validar campos del formulario antes de continuar
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // si el login fue exitoso, navegar a la pantalla principal
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else if (mounted) {
        // si falla, mostrar snackbar con mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'error al iniciar sesion'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // escucha el estado de autenticacion para mostrar cargando o no
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoading = authProvider.status == AuthStatus.authenticating;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              // animacion de opacidad para el contenido
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // icono de videojuego como logo
                  Icon(
                    Icons.sports_esports,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  // titulo de la aplicacion
                  Text(
                    'esports coach',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // subtitulo invitando a iniciar sesion
                  Text(
                    'inicia sesion para continuar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // formulario con campos de email y contraseña
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // campo de texto personalizado para correo electronico
                        CustomTextField(
                          label: 'correo electronico',
                          hint: 'ejemplo@correo.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'por favor, ingresa tu correo electronico';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'por favor, ingresa un correo electronico valido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // campo de texto personalizado para contraseña con icono de visibilidad
                        CustomTextField(
                          label: 'contrasena',
                          hint: '••••••••',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onSuffixIconPressed: _togglePasswordVisibility,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'por favor, ingresa tu contrasena';
                            }
                            if (value.length < 6) {
                              return 'la contrasena debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        // texto boton para recuperar contraseña (sin funcionalidad por ahora)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // navegacion a pantalla de recuperacion de contraseña
                            },
                            child: const Text('¿olvidaste tu contrasena?'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // boton personalizado para iniciar sesion, muestra indicador de carga si corresponde
                        CustomButton(
                          text: 'iniciar sesion',
                          onPressed: _login,
                          isLoading: isLoading,
                          isFullWidth: true,
                        ),
                        const SizedBox(height: 16),
                        // enlace a pantalla de registro si el usuario no tiene cuenta
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿no tienes una cuenta?',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.register);
                              },
                              child: const Text('registrate'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
