import 'package:flutter/material.dart';

/// Widget que muestra una tarjeta con animación para destacar una característica o servicio.
/// Usa un [AnimationController] externo para controlar las transiciones de escala y opacidad.
class AnimatedFeatureCard extends StatelessWidget {
  final String title;             // Título de la tarjeta
  final String description;       // Descripción breve de la característica
  final IconData icon;            // Icono representativo
  final double delay;             // Retardo para escalonar la animación
  final AnimationController controller; // Controlador de animación compartido
  final VoidCallback onTap;       // Callback cuando el usuario presiona la tarjeta

  const AnimatedFeatureCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.delay,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller, // Reconstruye cuando el controlador avanza
      builder: (context, child) {
        // Definimos animación de escala (0.8 → 1.0) usando intervalo basado en el retardo
        final Animation<double> scaleAnimation = Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              delay,         // Inicia después del retardo
              delay + 0.4,   // Termina en delay + 0.4
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        // Definimos animación de opacidad (0.0 → 1.0) con el mismo intervalo
        final Animation<double> opacityAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              delay,         // Inicia después del retardo
              delay + 0.4,   // Termina en delay + 0.4
              curve: Curves.easeOut,
            ),
          ),
        );

        return Transform.scale(
          scale: scaleAnimation.value, // Ajusta el tamaño según el valor animado
          child: Opacity(
            opacity: opacityAnimation.value, // Ajusta visibilidad según el valor animado
            child: child, // Contenido fijo de la tarjeta
          ),
        );
      },
      child: InkWell(
        onTap: onTap, // Navegación o acción al tocar la tarjeta
        borderRadius: BorderRadius.circular(16), // Radio de borde para el efecto de ondulación
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // Color de fondo según tema (claro/oscuro)
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2C2C2E)
                : Colors.white,
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26), // Sombra sutil
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Círculo contenedor del icono
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(51), // Fondo semitransparente
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary, // Color principal del tema
                ),
              ),
              const SizedBox(height: 16),
              // Título centrado y negrita
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Descripción con color adaptado al tema
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
