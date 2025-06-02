/*
  modelo que representa la cuenta de League of Legends de un usuario:
  - summonerName: nombre de invocador
  - summonerId: identificador unico del invocador
  - puuid: identificador global único
  - region: region del invocador (por ejemplo “EUW”, “NA”)
  - profileIconId: id del icono de perfil
  - summonerLevel: nivel de invocador
*/
class LolAccount {
  final String summonerName;
  final String summonerId;
  final String puuid;
  final String region;
  final int profileIconId;
  final int summonerLevel;

  /*
    constructor principal:
    todos los campos son requeridos y no pueden ser nulos
  */
  LolAccount({
    required this.summonerName,
    required this.summonerId,
    required this.puuid,
    required this.region,
    required this.profileIconId,
    required this.summonerLevel,
  });

  /*
    factory que crea una instancia de LolAccount a partir de un JSON:
    - asigna cada campo directamente desde el mapa JSON
  */
  factory LolAccount.fromJson(Map<String, dynamic> json) {
    return LolAccount(
      summonerName: json['summonerName'],
      summonerId: json['summonerId'],
      puuid: json['puuid'],
      region: json['region'],
      profileIconId: json['profileIconId'],
      summonerLevel: json['summonerLevel'],
    );
  }

  /*
    metodo que convierte la instancia a JSON:
    - devuelve un mapa con todos los campos necesarios
  */
  Map<String, dynamic> toJson() {
    return {
      'summonerName': summonerName,
      'summonerId': summonerId,
      'puuid': puuid,
      'region': region,
      'profileIconId': profileIconId,
      'summonerLevel': summonerLevel,
    };
  }
}

/*
  modelo que representa un usuario de la aplicacion:
  - incluye datos de autenticacion y perfil de League of Legends opcional
*/
class User {
  final String id;
  final String username;
  final String email;
  final String? profileImage;
  final String? tier; // Iron, Bronze, Silver, etc.
  final String? division; // I, II, III, IV
  final String? riotId; // Riot ID del usuario
  final String? mainRole;
  final List<String>? favoriteChampions;
  final bool isPremium;
  final String role;
  final LolAccount? lolAccount;

  /*
    constructor principal:
    - id, username y email son requeridos
    - profileImage, tier, division, riotId, mainRole, favoriteChampions y lolAccount son opcionales
    - isPremium tiene valor por defecto false
    - role tiene valor por defecto “user”
  */
  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.tier,
    this.division,
    this.riotId,
    this.mainRole,
    this.favoriteChampions,
    this.isPremium = false,
    this.role = 'user',
    this.lolAccount,
  });

  /*
    getter que devuelve el rango completo:
    - concatena tier y division si ambos existen
    - si falta alguno, retorna solo tier
  */
  String? get fullRank {
    if (tier != null && division != null) {
      return '$tier $division';
    }
    return tier;
  }

  /*
    getter de compatibilidad que retorna fullRank:
    - mantiene compatibilidad con posibles referencias a “rank” en lugar de “fullRank”
  */
  String? get rank => fullRank;

  /*
    factory que crea una instancia de User a partir de un JSON:
    - id se obtiene de '_id' o 'id' si existe
    - username y email se asignan directamente
    - profileImage, tier, division, riotId y mainRole se asignan si existen
    - favoriteChampions se convierte a List<String> si existe
    - isPremium se obtiene o se asume false si no existe
    - role se obtiene o se asume “user” por defecto
    - lolAccount se parsea usando LolAccount.fromJson si existe
  */
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profileImage'],
      tier: json['tier'],
      division: json['division'],
      riotId: json['riotId'],
      mainRole: json['mainRole'],
      favoriteChampions: json['favoriteChampions'] != null
          ? List<String>.from(json['favoriteChampions'])
          : null,
      isPremium: json['isPremium'] ?? false,
      role: json['role'] ?? 'user',
      lolAccount: json['lolAccount'] != null
          ? LolAccount.fromJson(json['lolAccount'])
          : null,
    );
  }

  /*
    metodo que convierte la instancia a JSON:
    - incluye id, username, email y todos los campos de perfil en un mapa
    - favoriteChampions se incluye aunque sea nula
    - lolAccount se convierte a JSON si no es nulo
  */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'tier': tier,
      'division': division,
      'riotId': riotId,
      'mainRole': mainRole,
      'favoriteChampions': favoriteChampions,
      'isPremium': isPremium,
      'role': role,
      'lolAccount': lolAccount?.toJson(),
    };
  }
}
