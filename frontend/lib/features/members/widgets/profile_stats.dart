import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int gamesPlayed;
  final int winRate;
  final int hoursCoached;

  const ProfileStats({
    Key? key,
    required this.gamesPlayed,
    required this.winRate,
    required this.hoursCoached,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // contenedor principal que agrupa las estadisticas
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color de fondo dinamico segun el tema
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2C2C2E)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // sombra sutil para dar relieve al contenedor
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        // fila para mostrar cada estadistica alineada horizontalmente
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // primer item: partidas jugadas
          _buildStatItem(
            context,
            '$gamesPlayed',
            'partidas',
            Icons.sports_esports,
          ),
          // divisor vertical entre items
          _buildDivider(),
          // segundo item: porcentaje de victorias
          _buildStatItem(
            context,
            '$winRate%',
            'victorias',
            Icons.emoji_events,
          ),
          // otro divisor vertical
          _buildDivider(),
          // tercer item: horas de coaching realizadas
          _buildStatItem(
            context,
            '$hoursCoached',
            'horas de coaching',
            Icons.access_time,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String value, String label, IconData icon) {
    return Column(
      // columna que agrupa icono, valor y etiqueta de cada estadistica
      children: [
        // icono representativo de la estadistica
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        // valor numerico o porcentaje
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
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

  Widget _buildDivider() {
    // linea vertical para separar items
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}
