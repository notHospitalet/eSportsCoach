import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/content_model.dart';
import '../../../shared/widgets/custom_button.dart';

class ContentDetailScreen extends StatelessWidget {
  final Content content;
  final bool isPremiumUser;

  const ContentDetailScreen({
    Key? key,
    required this.content,
    this.isPremiumUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // app bar flexible con imagen de fondo que se expande al hacer scroll
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: content.thumbnailUrl != null
                  ? Image.network(
                      content.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // si no carga la imagen, mostrar icono de placeholder
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported, size: 50),
                        );
                      },
                    )
                  : Container(
                      // si no hay url de thumbnail, mostrar fondo de color con icono generico
                      color: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.article, size: 50, color: Colors.white),
                    ),
            ),
          ),

          // contenido principal debajo del app bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // encabezado con tipo de contenido y etiqueta de premium si aplica
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          // color segun tipo de contenido
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            // fondo para etiqueta de premium
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
                  const SizedBox(height: 16),

                  // titulo principal del contenido
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // fecha de publicacion formateada
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.black45,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMMM, yyyy').format(content.publishedAt),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white54
                              : Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // lista de chips con las etiquetas del contenido
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: content.tags.map((tag) => Chip(
                      label: Text(tag),
                      padding: const EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                  const SizedBox(height: 24),

                  // descripcion breve del contenido
                  Text(
                    content.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // si es contenido premium y el usuario no tiene acceso, mostrar pantalla de bloqueo
                  if (content.isPremium && !isPremiumUser)
                    _buildPremiumContent(context)
                  else
                    _buildFreeContent(context),

                  const SizedBox(height: 32),

                  // seccion de contenido relacionado (placeholder si no hay)
                  const Text(
                    'Contenido relacionado',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No hay contenido relacionado disponible',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white54
                              : Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // construye vista de contenido gratuito (texto o video simulado)
  Widget _buildFreeContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content.type == ContentType.video)
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.black,
            child: const Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 64,
                color: Colors.white,
              ),
            ),
          )
        else
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam euismod, nisl eget aliquam ultricies, nunc nisl aliquet nunc, quis aliquam nisl nunc quis nisl. Nullam euismod, nisl eget aliquam ultricies, nunc nisl aliquet nunc, quis aliquam nisl nunc quis nisl.\n\nNullam euismod, nisl eget aliquam ultricies, nunc nisl aliquet nunc, quis aliquam nisl nunc quis nisl. Nullam euismod, nisl eget aliquam ultricies, nunc nisl aliquet nunc, quis aliquam nisl nunc quis nisl.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
      ],
    );
  }

  // construye vista para contenido premium bloqueado
  Widget _buildPremiumContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800.withAlpha(76)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withAlpha(128),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.lock,
            size: 48,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Contenido Premium',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Este contenido es exclusivo para miembros premium. Suscríbete para acceder a todo nuestro contenido exclusivo.',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Suscribirse',
            onPressed: () {
              // navegacion a pantalla de miembros para suscripcion
              Navigator.pushNamed(context, '/members');
            },
            type: ButtonType.secondary,
          ),
        ],
      ),
    );
  }

  // selecciona color de etiqueta segun tipo de contenido
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

  // texto para tipo de contenido
  String _getContentTypeText(ContentType type) {
    switch (type) {
      case ContentType.article:
        return 'Artículo';
      case ContentType.video:
        return 'Video';
      case ContentType.guide:
        return 'Guía';
      case ContentType.analysis:
        return 'Análisis';
      default:
        return 'Contenido';
    }
  }
}
