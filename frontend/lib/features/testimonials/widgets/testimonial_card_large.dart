import 'package:flutter/material.dart';
import '../../../data/models/testimonial_model.dart';

class TestimonialCardLarge extends StatelessWidget {
  final Testimonial testimonial;

  const TestimonialCardLarge({
    Key? key,
    required this.testimonial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // sin sombra para mantener un aspecto limpio
      elevation: 0,
      // borde redondeado y contorno para separar la tarjeta del fondo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          // color de borde cambia segun el tema (claro/oscuro)
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        // espacio interior alrededor del contenido
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // avatar del usuario que envio el testimonio
                CircleAvatar(
                  radius: 30,
                  // si hay url de avatar, se carga imagen de red
                  backgroundImage: testimonial.avatarUrl != null
                      ? NetworkImage(testimonial.avatarUrl!)
                      : null,
                  child: testimonial.avatarUrl == null
                      // si no hay imagen, se muestra inicial del nombre
                      ? Text(
                          testimonial.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  // columna con nombre y calificacion en estrellas
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // nombre del usuario que dio el testimonio
                      Text(
                        testimonial.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // fila de iconos de estrellas segun la calificacion
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < testimonial.rating.floor()
                                ? Icons.star
                                : (index < testimonial.rating
                                    ? Icons.star_half
                                    : Icons.star_border),
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                // mostrar el cambio de rango si ambos valores estan presentes
                if (testimonial.initialRank != null && testimonial.currentRank != null)
                  Container(
                    // contenedor con fondo suave para resaltar los rangos
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // rango inicial
                        Text(
                          testimonial.initialRank!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_downward,
                          size: 16,
                        ),
                        // rango actual despues del coaching
                        Text(
                          testimonial.currentRank!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // texto del comentario entre comillas y estilo cursiva
            Text(
              '"${testimonial.comment}"',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.5,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
