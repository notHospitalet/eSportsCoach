class Champions {
  /*
    lista estatica de campeones de league of legends:
    contiene nombres de todos los campeones disponibles
  */
  static const List<String> all = [
    'Aatrox', 'Ahri', 'Akali', 'Akshan', 'Alistar', 'Amumu', 'Anivia', 'Annie',
    'Aphelios', 'Ashe', 'Aurelion Sol', 'Azir', 'Bard', 'Bel\'Veth', 'Blitzcrank',
    'Brand', 'Braum', 'Briar', 'Caitlyn', 'Camille', 'Cassiopeia', 'Cho\'Gath',
    'Corki', 'Darius', 'Diana', 'Dr. Mundo', 'Draven', 'Ekko', 'Elise', 'Evelynn',
    'Ezreal', 'Fiddlesticks', 'Fiora', 'Fizz', 'Galio', 'Gangplank', 'Garen',
    'Gnar', 'Gragas', 'Graves', 'Gwen', 'Hecarim', 'Heimerdinger', 'Hwei',
    'Illaoi', 'Irelia', 'Ivern', 'Janna', 'Jarvan IV', 'Jax', 'Jayce', 'Jhin',
    'Jinx', 'K\'Sante', 'Kai\'Sa', 'Kalista', 'Karma', 'Karthus', 'Kassadin',
    'Katarina', 'Kayle', 'Kayn', 'Kennen', 'Kha\'Zix', 'Kindred', 'Kled',
    'Kog\'Maw', 'LeBlanc', 'Lee Sin', 'Leona', 'Lillia', 'Lissandra', 'Lucian',
    'Lulu', 'Lux', 'Malphite', 'Malzahar', 'Maokai', 'Master Yi', 'Milio',
    'Miss Fortune', 'Mordekaiser', 'Morgana', 'Naafiri', 'Nami', 'Nasus',
    'Nautilus', 'Neeko', 'Nidalee', 'Nilah', 'Nocturne', 'Nunu & Willump',
    'Olaf', 'Orianna', 'Ornn', 'Pantheon', 'Poppy', 'Pyke', 'Qiyana', 'Quinn',
    'Rakan', 'Rammus', 'Rek\'Sai', 'Rell', 'Renata Glasc', 'Renekton',
    'Rengar', 'Riven', 'Rumble', 'Ryze', 'Samira', 'Sejuani', 'Senna',
    'Seraphine', 'Sett', 'Shaco', 'Shen', 'Shyvana', 'Singed', 'Sion',
    'Sivir', 'Skarner', 'Sona', 'Soraka', 'Swain', 'Sylas', 'Syndra',
    'Tahm Kench', 'Taliyah', 'Talon', 'Taric', 'Teemo', 'Thresh', 'Tristana',
    'Trundle', 'Tryndamere', 'Twisted Fate', 'Twitch', 'Udyr', 'Urgot',
    'Varus', 'Vayne', 'Veigar', 'Vel\'Koz', 'Vex', 'Vi', 'Viego', 'Viktor',
    'Vladimir', 'Volibear', 'Warwick', 'Wukong', 'Xayah', 'Xerath', 'Xin Zhao',
    'Yasuo', 'Yone', 'Yorick', 'Yuumi', 'Zac', 'Zed', 'Zeri', 'Ziggs',
    'Zilean', 'Zoe', 'Zyra'
  ];

  /*
    metodo para buscar campeones segun un texto ingresado:
    - si el query esta vacio, retorna la lista completa
    - de lo contrario, filtra aquellos cuyos nombres contengan el texto ignorando mayusculas
  */
  static List<String> search(String query) {
    if (query.isEmpty) return all;

    return all.where((champion) =>
      champion.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
