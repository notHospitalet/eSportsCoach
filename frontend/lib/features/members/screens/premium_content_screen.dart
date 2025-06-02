import 'package:flutter/material.dart';
import '../../../data/models/content_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../content/widgets/content_detail_screen.dart';

class PremiumContentScreen extends StatelessWidget {
  PremiumContentScreen({Key? key}) : super(key: key);

  // datos de ejemplo para contenido premium
  final List<Content> _premiumContent = [
    Content(
      id: '1',
      title: 'Guía avanzada de wave management',
      description:
          'Aprende tecnicas avanzadas de control de oleadas para dominar la fase de linea y crear ventajas significativas.',
      thumbnailUrl: 'https://via.placeholder.com/300x200',
      type: ContentType.guide,
      tags: ['Wave Management', 'Laning', 'Advanced'],
      publishedAt: DateTime.now(),
      isPremium: true,
    ),
    Content(
      id: '2',
      title: 'Análisis de partidas profesionales: Worlds 2023',
      description:
          'Desglose detallado de las estrategias y decisiones clave en las partidas más importantes del campeonato mundial.',
      thumbnailUrl: 'https://via.placeholder.com/300x200',
      type: ContentType.analysis,
      tags: ['Pro Play', 'Worlds', 'Analysis'],
      publishedAt: DateTime.now(),
      isPremium: true,
    ),
    Content(
      id: '3',
      title: 'Masterclass: Posicionamiento en teamfights',
      description:
          'Aprende a posicionarte correctamente en peleas de equipo segun tu rol y campeon para maximizar tu impacto.',
      thumbnailUrl: 'https://via.placeholder.com/300x200',
      type: ContentType.video,
      tags: ['Teamfight', 'Positioning', 'Advanced'],
      publishedAt: DateTime.now(),
      isPremium: true,
    ),
    Content(
      id: '4',
      title: 'Guía definitiva de vision y control de objetivos',
      description:
          'Todo lo que necesitas saber sobre el control de vision y como utilizarlo para asegurar objetivos importantes.',
      thumbnailUrl: 'https://via.placeholder.com/300x200',
      type: ContentType.guide,
      tags: ['Vision', 'Objectives', 'Map Control'],
      publishedAt: DateTime.now(),
      isPremium: true,
    ),
    Content(
      id: '5',
      title: 'Comunicacion efectiva en equipos competitivos',
      description:
          'Aprende a comunicarte de manera clara y eficiente con tu equipo para mejorar la coordinacion y toma de decisiones.',
      thumbnailUrl: 'https://via.placeholder.com/300x200',
      type: ContentType.article,
      tags: ['Communication', 'Team Play', 'Competitive'],
      publishedAt: DateTime.now(),
      isPremium: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // titulo de la appbar
        title: const Text('contenido premium'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // banner con informacion general del contenido premium
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // titulo principal del banner
                Text(
                  'contenido exclusivo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                // subtitulo con descripcion breve
                Text(
                  'accede a guias, analisis y videos exclusivos para miembros premium',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // lista de tarjetas para cada contenido premium
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _premiumContent.length,
              itemBuilder: (context, index) {
                final content = _premiumContent[index];
                return _buildPremiumContentCard(context, content);
              },
            ),
          ),
        ],
      ),
    );
  }

  // metodo que construye cada tarjeta de contenido premium
  Widget _buildPremiumContentCard(BuildContext context, Content content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        // accion al presionar la tarjeta: navega a la pantalla de detalle
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContentDetailScreen(
                content: content,
                isPremiumUser: true,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // imagen superior del contenido
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                content.thumbnailUrl ?? 'https://via.placeholder.com/300x200',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // placeholder en caso de error cargando la imagen
                  return Container(
                    height: 150,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // fila con tipo de contenido y etiqueta premium
                  Row(
                    children: [
                      // etiqueta que muestra el tipo de contenido (guia, video, articulo, analisis)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                      // indicador de que es contenido premium
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'premium',
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

                  // titulo del contenido premium
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

                  // descripcion breve del contenido
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

                  // lista de chips con las etiquetas o tags del contenido
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: content.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              padding: const EdgeInsets.all(0),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // boton para ver el contenido premium
                  CustomButton(
                    text: 'ver contenido',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContentDetailScreen(
                            content: content,
                            isPremiumUser: true,
                          ),
                        ),
                      );
                    },
                    type: ButtonType.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // metodo que retorna el color segun el tipo de contenido
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

  // metodo que retorna el texto del tipo de contenido
  String _getContentTypeText(ContentType type) {
    switch (type) {
      case ContentType.article:
        return 'articulo';
      case ContentType.video:
        return 'video';
      case ContentType.guide:
        return 'guia';
      case ContentType.analysis:
        return 'analisis';
      default:
        return 'contenido';
    }
  }
}
