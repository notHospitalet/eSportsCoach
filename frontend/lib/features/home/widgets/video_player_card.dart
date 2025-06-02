import 'package:flutter/material.dart';

/// Tarjeta que simula un reproductor de video mostrando una miniatura (thumbnail)
/// con un botón de reproducción superpuesto.
class VideoPlayerCard extends StatelessWidget {
  final String videoUrl;      // URL del video (para futura integración del reproductor)
  final String thumbnailUrl;  // Ruta/localización de la imagen miniatura
  final double height;        // Altura fija de la tarjeta

  const VideoPlayerCard({
    Key? key,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.height = 200, // Valor predeterminado si no se especifica
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, // Altura de la tarjeta según el parámetro
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50), // Sombra suave para dar relieve
            blurRadius: 10,
            offset: const Offset(0, 5),        // Desplazamiento de la sombra
          ),
        ],
      ),
      // ClipRRect para aplicar el borde redondeado al contenido interno
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand, // Ocupa todo el espacio disponible
          children: [
            // Miniatura del video (thumbnail)
            Image.asset(
              thumbnailUrl,
              fit: BoxFit.cover, // Ajusta la imagen para cubrir todo el contenedor
              errorBuilder: (context, error, stackTrace) => Container(
                // En caso de error al cargar la imagen, se muestra un recuadro gris
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.image_not_supported,
                  size: 50,
                ),
              ),
            ),
            // Capa semitransparente oscura con ícono de "play" en el centro
            Container(
              color: Colors.black.withAlpha(100), // Superposición oscura
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill, // Ícono que representa reproducción
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
