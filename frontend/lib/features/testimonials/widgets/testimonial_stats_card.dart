import 'package:flutter/material.dart';

class TestimonialStatsCard extends StatelessWidget {
  final int totalTestimonials;
  final double averageRating;
  final bool isLoading;

  const TestimonialStatsCard({
    Key? key,
    required this.totalTestimonials,
    required this.averageRating,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // si aun se estan cargando los datos, mostrar indicador de progreso
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      // padding interno para separar el contenido de los bordes
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color de fondo igual al color de tarjeta del tema actual
        color: Theme.of(context).cardColor,
        // bordes redondeados para aspecto mas suave
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // sombra suave debajo de la tarjeta para dar profundidad
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        // distribuir elementos de estadisticas con espacio alrededor
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // primer item: total de testimonios
          _buildStatItem(
            context,
            Icons.format_quote,
            '$totalTestimonials+',
            'testimonios',
          ),
          // divisor vertical para separar visualmente las estadisticas
          Container(
            height: 60,
            width: 1,
            color: Colors.grey.shade300,
          ),
          // segundo item: promedio de valoracion
          _buildStatItem(
            context,
            Icons.star,
            averageRating.toStringAsFixed(1),
            'valoracion',
          ),
          // otro divisor vertical
          Container(
            height: 60,
            width: 1,
            color: Colors.grey.shade300,
          ),
          // tercer item: exito (placeholder si no se calcula actualmente)
          _buildStatItem(
            context,
            Icons.emoji_events,
            'n/a', // placeholder, exito no calculado
            'exito',
          ),
        ],
      ),
    );
  }

  // metodo auxiliar para construir cada item de estadistica con icono, valor y etiqueta
  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        // icono que representa la estadistica (citas, estrellas, trofeo)
        Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        // valor numerico o texto de la estadistica en negrita
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // etiqueta descriptiva en texto mas pequeño y color gris
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
