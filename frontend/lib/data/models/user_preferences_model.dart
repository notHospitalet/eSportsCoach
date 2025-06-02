/*
  modelo que representa las preferencias del usuario tanto de juego como de la app:
  - incluye datos de League of Legends (tier, division, etc.)
  - preferencias de interfaz (darkMode, idioma, notificaciones)
  - preferencias de juego (modo de juego, horas disponibles, zona horaria)
  - marcas de tiempo de creacion y actualizacion
*/
class UserPreferences {
  // identificador unico de las preferencias (puede ser nulo al crear)
  final String? id;
  // id del usuario al que pertenecen estas preferencias
  final String userId;
  // liga (tier) de League of Legends (Iron, Bronze, Silver, etc.)
  final String? tier;
  // division dentro de la liga (I, II, III, IV)
  final String? division;
  // Riot ID del usuario
  final String? riotId;
  // rol principal del usuario (por ejemplo Support, ADC)
  final String? mainRole;
  // lista de campeones favoritos del usuario
  final List<String>? favoriteChampions;
  // flag que indica si el usuario prefiere tema oscuro (true) o claro (false)
  final bool darkMode;
  // idioma de la aplicacion (por defecto 'es')
  final String language;
  // flag para habilitar notificaciones dentro de la app
  final bool notifications;
  // flag para habilitar notificaciones por correo
  final bool emailNotifications;
  // modo de juego preferido (por ejemplo ranked, normal, aram)
  final String? preferredGameMode;
  // lista de horas disponibles para sesiones (por ejemplo ['18:00', '20:00'])
  final List<String>? availableHours;
  // zona horaria del usuario (por ejemplo 'Europe/Madrid')
  final String? timezone;
  // marca de tiempo cuando se crearon estas preferencias
  final DateTime createdAt;
  // marca de tiempo de la ultima actualizacion de estas preferencias
  final DateTime updatedAt;

  /*
    constructor principal:
    - id es opcional (nullable)
    - userId es requerido
    - tier, division, riotId, mainRole, favoriteChampions son opcionales
    - darkMode por defecto true
    - language por defecto 'es'
    - notifications y emailNotifications por defecto true
    - preferredGameMode, availableHours, timezone son opcionales
    - createdAt y updatedAt son requeridos
  */
  UserPreferences({
    this.id,
    required this.userId,
    this.tier,
    this.division,
    this.riotId,
    this.mainRole,
    this.favoriteChampions,
    this.darkMode = true,
    this.language = 'es',
    this.notifications = true,
    this.emailNotifications = true,
    this.preferredGameMode,
    this.availableHours,
    this.timezone,
    required this.createdAt,
    required this.updatedAt,
  });

  /*
    getter para obtener el rango completo combinando tier y division:
    - si ambos existen, retorna "tier division"
    - si solo tier existe, retorna tier
    - si ninguno existe, retorna null
  */
  String? get fullRank {
    if (tier != null && division != null) {
      return '$tier $division';
    }
    return tier;
  }

  /*
    factory que crea una instancia de UserPreferences desde un JSON:
    - maneja valores nulos asignando valores por defecto
    - convierten listas de strings cuando existen
    - parsean createdAt y updatedAt usando DateTime.parse o DateTime.now() si no existen
  */
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      id: json['id'],
      userId: json['userId'] ?? '',
      tier: json['tier'],
      division: json['division'],
      riotId: json['riotId'],
      mainRole: json['mainRole'],
      favoriteChampions: json['favoriteChampions'] != null
          ? List<String>.from(json['favoriteChampions'])
          : null,
      darkMode: json['darkMode'] ?? true,
      language: json['language'] ?? 'es',
      notifications: json['notifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      preferredGameMode: json['preferredGameMode'],
      availableHours: json['availableHours'] != null
          ? List<String>.from(json['availableHours'])
          : null,
      timezone: json['timezone'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /*
    metodo que convierte la instancia a JSON para enviar al servidor:
    - incluye todos los campos
    - formatea createdAt y updatedAt a ISO 8601
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tier': tier,
      'division': division,
      'riotId': riotId,
      'mainRole': mainRole,
      'favoriteChampions': favoriteChampions,
      'darkMode': darkMode,
      'language': language,
      'notifications': notifications,
      'emailNotifications': emailNotifications,
      'preferredGameMode': preferredGameMode,
      'availableHours': availableHours,
      'timezone': timezone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /*
    metodo copyWith para clonar y actualizar campos de la instancia:
    - permite sobreescribir cualquier campo opcionalmente
    - si no se proporciona un nuevo valor, se mantiene el valor actual
  */
  UserPreferences copyWith({
    String? id,
    String? userId,
    String? tier,
    String? division,
    String? riotId,
    String? mainRole,
    List<String>? favoriteChampions,
    bool? darkMode,
    String? language,
    bool? notifications,
    bool? emailNotifications,
    String? preferredGameMode,
    List<String>? availableHours,
    String? timezone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserPreferences(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tier: tier ?? this.tier,
      division: division ?? this.division,
      riotId: riotId ?? this.riotId,
      mainRole: mainRole ?? this.mainRole,
      favoriteChampions: favoriteChampions ?? this.favoriteChampions,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      notifications: notifications ?? this.notifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      preferredGameMode: preferredGameMode ?? this.preferredGameMode,
      availableHours: availableHours ?? this.availableHours,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
