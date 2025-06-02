import 'package:flutter/material.dart';

/// widget que muestra el perfil del coach:
/// - avatar circular con foto de red
/// - nombre y titulo centrados
/// - fila con rango y experiencia
class CoachProfile extends StatelessWidget {
  final String name;
  final String title;
  final String imageUrl;
  final String rank;
  final String experience;

  const CoachProfile({
    Key? key,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.rank,
    required this.experience,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // avatar circular con imagen remota
        CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: Colors.white,
          onBackgroundImageError: (exception, stackTrace) {
            // fallback si no se carga la imagen (puede mostrarse un placeholder aquí)
          },
        ),
        const SizedBox(height: 16),
        // nombre del coach en texto grande y negrita
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        // subtitulo o descripcion breve del coach
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // fila con dos estadisticas: rango y experiencia
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileStat('rango', rank),
            // separador vertical deslustrado
            Container(
              height: 24,
              width: 1,
              color: Colors.white30,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            _buildProfileStat('experiencia', experience),
          ],
        ),
      ],
    );
  }

  /// construye columna pequeña con etiqueta y valor para estadisticas de perfil
  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
