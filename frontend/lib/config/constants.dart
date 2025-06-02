class AppConstants {
  // configuracion de la api: url base para llamadas HTTP
  static const String apiUrl = 'http://localhost:8080/api';
  
  // informacion de la aplicacion: nombre y version
  static const String appName = 'eSports Coach';
  static const String appVersion = '1.0.0';
  
  // claves de almacenamiento local: para token, datos de usuario y tema
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  
  // paginacion: tamano de pagina por defecto para listados
  static const int defaultPageSize = 10;
  
  // tiempos de espera en milisegundos: conexion y recepcion de datos
  static const int connectionTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos
}
