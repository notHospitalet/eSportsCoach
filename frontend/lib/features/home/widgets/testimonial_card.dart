import 'package:flutter/material.dart';
import '../../../data/models/testimonial_model.dart';

/// Tarjeta que muestra la información de un testimonio de un usuario,
/// incluyendo avatar, nombre, cambios de rango, calificación y comentario.
class TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;

  const TestimonialCard({
    Key? key,
    required this.testimonial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Sin sombra adicional, aspecto plano
      child: Padding(
        padding: const EdgeInsets.all(16), // Espaciado interno uniforme
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinear contenido a la izquierda
          children: [
            // Fila con avatar y datos de usuario
            Row(
              children: [
                // Avatar circular del usuario
                CircleAvatar(
                  radius: 24, // Radio fijo para el avatar
                  backgroundImage: testimonial.avatarUrl != null
                      ? NetworkImage(testimonial.avatarUrl!) // Cargar imagen si existe URL
                      : null,
                  child: testimonial.avatarUrl == null
                      ? Text(
                          // Si no hay URL de imagen, mostrar inicial del nombre
                          testimonial.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12), // Separación horizontal entre avatar y texto
                Expanded(
                  // Expande para ocupar el espacio restante
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Alinear texto a la izquierda
                    children: [
                      // Nombre del usuario
                      Text(
                        testimonial.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Mostrar cambio de rango si ambos valores están presentes
                      if (testimonial.initialRank != null &&
                          testimonial.currentRank != null)
                        Text(
                          '${testimonial.initialRank} → ${testimonial.currentRank}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12), // Espacio vertical entre secciones
            // Fila con estrellas según la calificación (rating)
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < testimonial.rating.floor()
                      ? Icons.star                 // Estrella llena si el índice es menor al entero de rating
                      : (index < testimonial.rating
                          ? Icons.star_half       // Estrella a la mitad si está entre entero y decimal
                          : Icons.star_border),   // Estrella vacía en caso contrario
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 12), // Separación antes del comentario
            // Comentario del usuario, con límite de líneas y elipsis
            Expanded(
              child: Text(
                testimonial.comment,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54,
                ),
                maxLines: 4,              // Máximo de 4 líneas antes de recortar
                overflow: TextOverflow.ellipsis, // Mostrar "..." si supera el límite
              ),
            ),
          ],
        ),
      ),
    );
  }
}
