import 'package:flutter/material.dart';
import '../../../config/routes.dart';
import '../../../shared/widgets/custom_button.dart';

/// Banner principal de la pantalla de inicio.
/// Muestra un gradiente de fondo, elementos decorativos y contenido de llamada a la acción.
class HomeBanner extends StatelessWidget {
  const HomeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,       // Ocupa todo el ancho disponible
      height: 400,                  // Altura fija para el banner
      decoration: BoxDecoration(
        // Gradiente vertical que va del color primario a una versión más translúcida
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Círculo decorativo en la parte superior derecha
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1), // Transparencia sutil
              ),
            ),
          ),
          // Círculo decorativo en la parte inferior izquierda
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1), // Transparencia sutil
              ),
            ),
          ),
          
          // Contenido principal del banner
          Padding(
            padding: const EdgeInsets.all(24), // Espaciado interno cómodo
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
              crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
              children: [
                // Título en dos líneas
                const Text(
                  'LLEVA TU JUEGO AL\nSIGUIENTE NIVEL',
                  style: TextStyle(
                    fontSize: 32,               // Tamaño de fuente grande
                    fontWeight: FontWeight.bold, // Negrita para destacar
                    color: Colors.white,         // Color blanco para contrastar con el fondo
                    height: 1.2,                 // Espaciado entre líneas
                  ),
                ),
                const SizedBox(height: 16),      // Separación entre título y subtítulo
                // Subtítulo explicativo
                const Text(
                  'Coaching personalizado para jugadores de League of Legends\nque quieren mejorar y alcanzar sus objetivos',
                  style: TextStyle(
                    fontSize: 16,              // Tamaño de fuente estándar
                    color: Colors.white,       // Color blanco para legibilidad
                    height: 1.5,               // Espaciado de texto
                  ),
                ),
                const SizedBox(height: 32),      // Separación antes de los botones
                Row(
                  children: [
                    // Botón secundario para reservar una sesión
                    CustomButton(
                      text: 'Reserva una sesión',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.contact);
                      },
                      type: ButtonType.secondary,
                    ),
                    const SizedBox(width: 16),  // Espacio horizontal entre botones
                    // Botón con borde para navegar a la sección "Acerca de"
                    CustomButton(
                      text: 'Conoce más',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.about);
                      },
                      type: ButtonType.outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
