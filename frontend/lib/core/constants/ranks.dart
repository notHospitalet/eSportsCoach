import 'package:flutter/material.dart';

/*
  clase que define las divisiones y representaciones visuales de los rangos:
  - tiers: mapa de tier a lista de divisiones disponibles
  - allTiers: lista de todos los tiers
  - getDivisionsForTier: retorna las divisiones para un tier dado
  - getRankIcon: retorna un icono unicode segun el tier
  - getRankColor: retorna un color asociado al tier
*/
class Ranks {
  /*
    mapa estatico que relaciona cada tier con sus divisiones:
    - niveles basados en ligas de league of legends
  */
  static const Map<String, List<String>> tiers = {
    'Iron': ['IV', 'III', 'II', 'I'],
    'Bronze': ['IV', 'III', 'II', 'I'],
    'Silver': ['IV', 'III', 'II', 'I'],
    'Gold': ['IV', 'III', 'II', 'I'],
    'Platinum': ['IV', 'III', 'II', 'I'],
    'Emerald': ['IV', 'III', 'II', 'I'],
    'Diamond': ['IV', 'III', 'II', 'I'],
    'Master': ['I'],
    'Grandmaster': ['I'],
    'Challenger': ['I'],
  };

  // lista de todos los tiers disponibles (claves del mapa)
  static List<String> get allTiers => tiers.keys.toList();

  /*
    metodo que devuelve las divisiones asociadas a un tier:
    - si el tier no existe en el mapa, retorna lista vacia
  */
  static List<String> getDivisionsForTier(String tier) {
    return tiers[tier] ?? [];
  }

  /*
    metodo que asigna un icono unicode basado en el nombre del tier:
    - los tiers inferiores usan medallas, los mas altos usan iconos de estrella o corona
    - retorna un icono generico si el tier no coincide con ninguno
  */
  static String getRankIcon(String tier) {
    switch (tier.toLowerCase()) {
      case 'iron':
        return '🥉';
      case 'bronze':
        return '🥉';
      case 'silver':
        return '🥈';
      case 'gold':
        return '🥇';
      case 'platinum':
        return '💎';
      case 'emerald':
        return '💚';
      case 'diamond':
        return '💎';
      case 'master':
        return '👑';
      case 'grandmaster':
        return '👑';
      case 'challenger':
        return '⭐';
      default:
        return '🎮';
    }
  }

  /*
    metodo que asigna un color a cada tier para uso en la interfaz:
    - colores basados en representacion comun de ligas (oro, plata, etc.)
    - retorna color neutro si el tier no coincide con ninguno
  */
  static Color getRankColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'iron':
        return const Color(0xFF8B4513);
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'platinum':
        return const Color(0xFF00CED1);
      case 'emerald':
        return const Color(0xFF50C878);
      case 'diamond':
        return const Color(0xFFB9F2FF);
      case 'master':
        return const Color(0xFF9932CC);
      case 'grandmaster':
        return const Color(0xFFDC143C);
      case 'challenger':
        return const Color(0xFFF7E7CE);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

/*
  clase que contiene una lista estatica de todos los rangos posibles:
  - cada elemento combina tier y division en un solo string
  - incluye los tiers sin division (master, grandmaster, challenger)
*/
class RankConstants {
  static const List<String> allRanks = [
    'Iron IV',
    'Iron III',
    'Iron II',
    'Iron I',
    'Bronze IV',
    'Bronze III',
    'Bronze II',
    'Bronze I',
    'Silver IV',
    'Silver III',
    'Silver II',
    'Silver I',
    'Gold IV',
    'Gold III',
    'Gold II',
    'Gold I',
    'Platinum IV',
    'Platinum III',
    'Platinum II',
    'Platinum I',
    'Diamond IV',
    'Diamond III',
    'Diamond II',
    'Diamond I',
    'Master',
    'Grandmaster',
    'Challenger'
  ];
}
