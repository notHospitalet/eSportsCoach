/*
  enumeracion que define los tipos de servicio disponibles:
  - individual: sesion 1 a 1
  - monthly: plan mensual
  - course: curso estructurado
  - guide: paquete de guia o material
  - team: sesion grupal para equipos
*/
enum ServiceType {
  individual,
  monthly,
  course,
  guide,
  team,
}

/*
  modelo que representa un servicio ofrecido en la aplicacion:
  - id: identificador unico
  - title: titulo del servicio
  - description: descripcion detallada
  - price: precio del servicio
  - type: tipo de servicio (usar enumeracion ServiceType)
  - imageUrl: url de la imagen asociada al servicio (opcional)
  - features: lista de caracteristicas o beneficios incluidos
  - durationMinutes: duracion en minutos del servicio
  - isPopular: flag que indica si el servicio es popular (por defecto false)
*/
class Service {
  final String id;
  final String title;
  final String description;
  final double price;
  final ServiceType type;
  final String? imageUrl;
  final List<String> features;
  final int durationMinutes;
  final bool isPopular;

  /*
    constructor principal:
    - todos los campos marcados como required deben proporcionarse
    - imageUrl es opcional (nullable)
    - isPopular tiene valor por defecto false
  */
  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    this.imageUrl,
    required this.features,
    required this.durationMinutes,
    this.isPopular = false,
  });

  /*
    factory que crea una instancia de Service a partir de un JSON:
    - id se obtiene de la clave '_id'
    - price se convierte a double
    - type se parsea comparando la representacion string del enum con el valor JSON
      y se asigna individual por defecto si no coincide ninguno
    - features se convierte a List<String> usando List.from
    - durationMinutes se asigna directamente
    - isPopular se obtiene o se asume false si no existe en el JSON
  */
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      type: ServiceType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ServiceType.individual,
      ),
      imageUrl: json['imageUrl'],
      features: List<String>.from(json['features']),
      durationMinutes: json['durationMinutes'],
      isPopular: json['isPopular'] ?? false,
    );
  }

  /*
    método que convierte la instancia a JSON:
    - '_id' para id
    - convertir type a string usando enum.toString().split('.').last
    - price, features, durationMinutes e isPopular se incluyen directamente
    - imageUrl se incluye aunque sea nulo
  */
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'price': price,
      'type': type.toString().split('.').last,
      'imageUrl': imageUrl,
      'features': features,
      'durationMinutes': durationMinutes,
      'isPopular': isPopular,
    };
  }
}
