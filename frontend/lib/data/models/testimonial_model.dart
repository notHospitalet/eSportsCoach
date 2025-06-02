/*
  modelo que representa un testimonio dentro de la aplicacion:
  incluye datos del autor, comentario, puntuacion, rangos, fecha y estado de aprobacion
*/
class Testimonial {
  final String id;
  final String name;
  final String? avatarUrl;
  final String comment;
  final double rating;
  final String? initialRank;
  final String? currentRank;
  final DateTime date;
  final bool isApproved;

  /*
    constructor principal:
    - id, name, comment, rating y date son obligatorios
    - avatarUrl, initialRank, currentRank son opcionales
    - isApproved indica si el testimonio fue aprobado (por defecto false)
  */
  Testimonial({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.comment,
    required this.rating,
    this.initialRank,
    this.currentRank,
    required this.date,
    this.isApproved = false,
  });

  /*
    factory que crea una instancia a partir de un JSON:
    - maneja valores nulos o formatos incorrectos usando valores por defecto
    - convierte rating a double si es num, de lo contrario asigna 0.0
    - parsea la fecha desde String, si falla usa DateTime.now()
    - isApproved se extrae como booleano o false si no existe
  */
  factory Testimonial.fromJson(Map<String, dynamic> json) {
    final id = json['_id'] as String? ?? '';
    final name = json['name'] as String? ?? '';
    final comment = json['comment'] as String? ?? '';
    final avatarUrl = json['avatarUrl'] as String?;

    final rating = json['rating'];
    final double parsedRating = (rating is num) ? rating.toDouble() : 0.0;

    final initialRank = json['initialRank'] as String?;
    final currentRank = json['currentRank'] as String?;

    final dateString = json['date'] as String?;
    final date = (dateString != null && dateString.isNotEmpty)
        ? DateTime.tryParse(dateString) ?? DateTime.now()
        : DateTime.now();

    final isApproved = json['isApproved'] as bool? ?? false;

    return Testimonial(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      comment: comment,
      rating: parsedRating,
      initialRank: initialRank,
      currentRank: currentRank,
      date: date,
      isApproved: isApproved,
    );
  }

  /*
    convierte la instancia a JSON para enviar al servidor:
    - incluye solo los campos necesarios
    - date se formatea a ISO 8601
    - isApproved no se incluye porque se gestiona en el backend
  */
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'comment': comment,
      'rating': rating,
      'initialRank': initialRank,
      'currentRank': currentRank,
      'date': date.toIso8601String(),
    };
  }
}
