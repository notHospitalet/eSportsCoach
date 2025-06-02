import 'package:flutter/material.dart';

/// Widget que representa un ítem de característica (feature) con ícono, título y descripción.
/// Utilizado para mostrar de forma consistente distintos servicios o funcionalidades.
class FeatureItem extends StatelessWidget {
  final IconData icon;        // Ícono representativo de la característica
  final String title;         // Título breve de la característica
  final String description;   // Descripción explicativa de la característica

  const FeatureItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,               // Sin sombra elevada, para un diseño más plano
      margin: const EdgeInsets.all(8), // Margen uniforme alrededor de la tarjeta
      child: Padding(
        padding: const EdgeInsets.all(16), // Espaciado interno consistente
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
          children: [
            // Ícono grande en la parte superior
            Icon(
              icon,
              size: 40, // Tamaño del ícono
              color: Theme.of(context).colorScheme.primary, // Color principal del tema
            ),
            const SizedBox(height: 12), // Espacio vertical entre ícono y título
            // Título de la característica
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,       // Tamaño de fuente del título
                fontWeight: FontWeight.bold, // Negrita para destacar
              ),
            ),
            const SizedBox(height: 8), // Espacio vertical entre título y descripción
            // Descripción de la característica
            Text(
              description,
              style: TextStyle(
                fontSize: 14, // Tamaño de fuente un poco más pequeño para el texto
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70  // Color más claro en modo oscuro
                    : Colors.black54, // Color grisáceo en modo claro
              ),
            ),
          ],
        ),
      ),
    );
  }
}
