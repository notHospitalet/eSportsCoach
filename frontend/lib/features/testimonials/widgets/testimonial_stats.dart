import 'package:flutter/material.dart';

class TestimonialStats extends StatelessWidget {
  final int totalStudents;
  final double averageRating;
  final int successRate;

  const TestimonialStats({
    Key? key,
    required this.totalStudents,
    required this.averageRating,
    required this.successRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding interno para separar el contenido de los bordes
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color de fondo segun el tema (claro u oscuro)
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2C2C2E)
            : Colors.white,
        // bordes redondeados para un aspecto mas suave
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // sombra suave para dar efecto de elevacion
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // fila principal que contiene los tres indicadores de estadisticas
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // primer indicador: total de estudiantes
          _buildStatItem(
            context,
            '$totalStudents+',
            'estudiantes',
            Icons.people,
          ),
          // divisor vertical para separar visualmente los indicadores
          _buildDivider(),
          // segundo indicador: valoracion promedio
          _buildStatItem(
            context,
            averageRating.toString(),
            'valoracion',
            Icons.star,
          ),
          // divisor vertical para separar visualmente los indicadores
          _buildDivider(),
          // tercer indicador: tasa de exito
          _buildStatItem(
            context,
            '$successRate%',
            'exito',
            Icons.emoji_events,
          ),
        ],
      ),
    );
  }

  // metodo privado que construye un elemento de estadistica con icono, valor y etiqueta
  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        // icono representativo de la estadistica
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        const SizedBox(height: 8),
        // texto que muestra el valor numerico o porcentaje de la estadistica
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        // etiqueta descriptiva de la estadistica
        Text(
          label,
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

  // metodo privado para crear un divisor vertical entre indicadores
  Widget _buildDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}
