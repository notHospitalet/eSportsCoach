import 'package:flutter/material.dart';

class ServiceCategoryHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const ServiceCategoryHeader({
    Key? key,
    required this.title,
    required this.icon,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // fila principal que contiene el icono y el titulo de la categoria
        Row(
          children: [
            // contenedor redondeado que envuelve el icono
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // color de fondo del icono con transparencia
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon, // icono que representa la categoria
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // texto del titulo de la categoria
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // descripcion breve debajo del titulo, con estilo dependiente del tema
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black54,
          ),
        ),
      ],
    );
  }
}
