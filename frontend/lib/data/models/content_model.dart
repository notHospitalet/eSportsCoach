/*
  enumeracion que define los tipos de contenido disponibles:
  - article: articulo
  - video: video
  - guide: guia
  - analysis: analisis
*/
enum ContentType {
  article,
  video,
  guide,
  analysis,
}

/*
  modelo que representa un contenido publicado:
  - id: identificador unico
  - title: titulo del contenido
  - description: descripcion breve
  - thumbnailUrl: url de la miniatura (opcional)
  - contentUrl: url del contenido principal (opcional, p.ej. video o enlace)
  - type: tipo de contenido (usar enumeracion ContentType)
  - tags: lista de etiquetas asociadas
  - publishedAt: fecha de publicacion
  - isPremium: flag que indica si el contenido es premium (por defecto false)
*/
class Content {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String? contentUrl;
  final ContentType type;
  final List<String> tags;
  final DateTime publishedAt;
  final bool isPremium;

  /*
    constructor principal:
    - todos los campos marcados como required deben proporcionarse
    - thumbnailUrl y contentUrl son opcionales (nullable)
    - isPremium tiene valor por defecto false
  */
  Content({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    this.contentUrl,
    required this.type,
    required this.tags,
    required this.publishedAt,
    this.isPremium = false,
  });

  /*
    factory que crea una instancia de Content a partir de un JSON:
    - id se obtiene de la clave '_id'
    - type se parsea comparando la representacion string del enum con el valor JSON
      y se asigna article por defecto si no coincide ninguno
    - tags se convierte a List<String> usando List.from
    - publishedAt se parsea con DateTime.parse
    - isPremium se obtiene o se asume false si no existe en el JSON
  */
  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      contentUrl: json['contentUrl'],
      type: ContentType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ContentType.article,
      ),
      tags: List<String>.from(json['tags']),
      publishedAt: DateTime.parse(json['publishedAt']),
      isPremium: json['isPremium'] ?? false,
    );
  }

  /*
    metodo que convierte la instancia a JSON:
    - '_id' para id
    - convertir type a string usando enum.toString().split('.').last
    - publishedAt a ISO 8601 string
    - isPremium se incluye siempre
  */
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'contentUrl': contentUrl,
      'type': type.toString().split('.').last,
      'tags': tags,
      'publishedAt': publishedAt.toIso8601String(),
      'isPremium': isPremium,
    };
  }
}
