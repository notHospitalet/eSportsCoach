import '../../core/api/api_client.dart';
import '../models/content_model.dart';

/// repositorio que gestiona las operaciones relacionadas con el contenido
class ContentRepository {
  /// cliente HTTP para realizar peticiones a la API
  final ApiClient _apiClient;

  /// constructor que acepta un ApiClient opcional o crea uno nuevo
  ContentRepository({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? ApiClient();

  /// obtiene la lista de contenidos con filtros opcionales:
  /// - type: filtra por tipo de contenido (article, video, etc.)
  /// - isPremium: filtra por contenido premium o gratuito
  /// - tag: filtra por etiqueta concreta
  Future<List<Content>> getContents({
    String? type,
    bool? isPremium,
    String? tag,
  }) async {
    // construir parámetros de consulta si se proporcionan
    final queryParams = <String, String>{};
    if (type != null) queryParams['type'] = type;
    if (isPremium != null) queryParams['isPremium'] = isPremium.toString();
    if (tag != null) queryParams['tag'] = tag;

    // generar cadena de consulta a partir del mapa de parámetros
    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';

    // realizar petición GET a 'content{?params}'
    final response = await _apiClient.get('content$queryString');
    // extraer lista de contenidos del JSON de respuesta
    final List<dynamic> contentsJson = response['data']['contents'];
    // mapear cada objeto JSON a instancia de Content
    return contentsJson.map((json) => Content.fromJson(json)).toList();
  }

  /// obtiene un contenido específico por su identificador:
  /// - realiza petición GET a 'content/{id}'
  /// - retorna la instancia de Content parseada desde el JSON
  Future<Content> getContentById(String id) async {
    final response = await _apiClient.get('content/$id');
    return Content.fromJson(response['data']['content']);
  }

  /// obtiene los contenidos más recientes:
  /// - acepta un límite opcional (por defecto 5)
  /// - realiza petición GET a 'content/latest?limit={limit}'
  /// - retorna lista de Content parseados desde la respuesta
  Future<List<Content>> getLatestContents({int limit = 5}) async {
    final response = await _apiClient.get('content/latest?limit=$limit');
    final List<dynamic> contentsJson = response['data']['contents'];
    return contentsJson.map((json) => Content.fromJson(json)).toList();
  }

  /// busca contenidos cuyo título o descripción coincida con la consulta:
  /// - realiza petición GET a 'content/search?q={query}'
  /// - retorna lista de Content parseados desde la respuesta
  Future<List<Content>> searchContents(String query) async {
    final response = await _apiClient.get('content/search?q=$query');
    final List<dynamic> contentsJson = response['data']['contents'];
    return contentsJson.map((json) => Content.fromJson(json)).toList();
  }
}
