import 'package:flutter/material.dart';

/// widget que muestra informacion de contacto en una tarjeta estilizada
class ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const ContactInfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // contenedor principal con padding y decoracion segun tema claro u oscuro
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2C2C2E) // fondo oscuro
            : Colors.white,            // fondo claro
        borderRadius: BorderRadius.circular(12), // bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // sombra suave
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // icono principal con color primario de tema
          Icon(
            icon,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          // titulo en negrita para representar el tipo de contacto
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // texto descriptivo que muestra el contenido de contacto
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70  // color secundario en modo oscuro
                  : Colors.black54, // color secundario en modo claro
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
