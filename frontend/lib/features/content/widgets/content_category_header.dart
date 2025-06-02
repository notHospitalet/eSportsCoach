import 'package:flutter/material.dart';

class ContentCategoryHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const ContentCategoryHeader({
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
        // fila principal que muestra el icono y el titulo de la categoria
        Row(
          children: [
            // contenedor del icono con fondo y bordes redondeados
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // color de fondo con opacidad para resaltar el icono
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
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
        // si la descripcion no esta vacia, mostrarla debajo del titulo
        if (description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              // color diferente segun tema oscuro o claro
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
        ],
      ],
    );
  }
}
