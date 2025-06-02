import 'package:flutter/material.dart';
import '../../data/models/content_model.dart';
import 'package:intl/intl.dart';

class ContentCard extends StatelessWidget {
  final Content content;
  final VoidCallback onTap;

  const ContentCard({
    Key? key,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // detector de gestos para capturar el tap y ejecutar la funcion onTap
      onTap: onTap,
      child: Card(
        // tarjeta con margenes verticales para separar elementos
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content.thumbnailUrl != null)
              // si existe una url de miniatura, se muestra la imagen recortada con bordes redondeados en la parte superior
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  content.thumbnailUrl!,
                  // se define la altura fija y el ancho ocupa todo el espacio disponible
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // en caso de error al cargar la imagen, se muestra un contenedor gris con un icono indicativo
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
              ),
            Padding(
              // padding alrededor del contenido textual dentro de la tarjeta
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // etiqueta que indica el tipo de contenido, con fondo de color segun el tipo
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getContentTypeColor(content.type, context),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _getContentTypeText(content.type),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (content.isPremium)
                        // etiqueta que marca como contenido premium si corresponde
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // titulo del contenido, con maximo de dos lineas y puntos suspensivos si excede
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // descripcion breve del contenido, con maximo de tres lineas y puntos suspensivos si excede
                  Text(
                    content.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // icono de calendario antes de la fecha de publicacion
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.black45,
                      ),
                      const SizedBox(width: 4),
                      // texto que muestra la fecha formateada segun locale
                      Text(
                        DateFormat('MMM dd, yyyy').format(content.publishedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white54
                              : Colors.black45,
                        ),
                      ),
                      const Spacer(),
                      // muestra hasta dos etiquetas asociadas al contenido como chips
                      ...content.tags.take(2).map((tag) => Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Chip(
                              label: Text(
                                tag,
                                style: const TextStyle(fontSize: 10),
                              ),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          )),
                      if (content.tags.length > 2)
                        // si hay mas de dos etiquetas, se muestra un chip indicando la cantidad restante
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Chip(
                            label: Text(
                              '+${content.tags.length - 2}',
                              style: const TextStyle(fontSize: 10),
                            ),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // metodo que retorna un color de fondo segun el tipo de contenido
  Color _getContentTypeColor(ContentType type, BuildContext context) {
    switch (type) {
      case ContentType.article:
        return Colors.blue;
      case ContentType.video:
        return Colors.red;
      case ContentType.guide:
        return Colors.green;
      case ContentType.analysis:
        return Colors.purple;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  // metodo que convierte el enum de tipo en texto legible
  String _getContentTypeText(ContentType type) {
    switch (type) {
      case ContentType.article:
        return 'Article';
      case ContentType.video:
        return 'Video';
      case ContentType.guide:
        return 'Guide';
      case ContentType.analysis:
        return 'Analysis';
      default:
        return 'Content';
    }
  }
}
