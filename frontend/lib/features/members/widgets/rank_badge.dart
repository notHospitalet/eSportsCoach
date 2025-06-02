import 'package:flutter/material.dart';

class RankBadge extends StatelessWidget {
  final String rank;

  const RankBadge({
    Key? key,
    required this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // contenedor que engloba el badge de rango
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // color de fondo segun el rango
        color: _getRankColor(rank),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        // fila para mostrar icono y texto juntos
        mainAxisSize: MainAxisSize.min,
        children: [
          // icono que representa el logro
          const Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          // texto con el rango del usuario
          Text(
            rank,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(String rank) {
    // funcion que retorna el color de fondo segun el texto del rango
    switch (rank) {
      case 'Iron':
        // color oscuro para iron
        return Colors.grey.shade700;
      case 'Bronze':
        // color marron para bronze
        return Colors.brown;
      case 'Silver':
        // color gris claro para silver
        return Colors.grey.shade400;
      case 'Gold':
        // color dorado para gold
        return Colors.amber;
      case 'Platinum':
        // color verde azulado para platinum
        return Colors.teal;
      case 'Diamond':
        // color azul claro para diamond
        return Colors.lightBlue;
      case 'Master':
        // color morado para master
        return Colors.purple;
      case 'Grandmaster':
        // color rojo para grandmaster
        return Colors.red;
      case 'Challenger':
        // color naranja para challenger
        return Colors.orange;
      default:
        // color gris generico para rangos desconocidos
        return Colors.grey;
    }
  }
}
