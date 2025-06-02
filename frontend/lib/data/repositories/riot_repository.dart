import '../../core/api/api_client.dart';
import '../../core/errors/api_exception.dart';

/// repositorio que gestiona las peticiones a la API de Riot:
/// - busqueda de invocador
/// - obtencion de estadisticas
/// - vinculacion de cuenta
class RiotRepository {
  /// cliente HTTP para realizar las peticiones
  final ApiClient _apiClient;

  /// constructor que permite inyectar un ApiClient o crear uno por defecto
  RiotRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// busca un invocador por nombre en la region especificada (por defecto 'euw1')
  /// - realiza GET a 'riot/search?summonerName={nombre}&region={region}'
  /// - retorna el mapa con los datos del invocador dentro de 'summoner'
  /// - si la respuesta es 404, lanza ApiException con mensaje 'invocador no encontrado'
  Future<Map<String, dynamic>> searchSummoner(String summonerName, {String region = 'euw1'}) async {
    try {
      final response = await _apiClient.get('riot/search?summonerName=$summonerName&region=$region');
      return response['data']['summoner'];
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) {
        throw ApiException('invocador no encontrado');
      }
      rethrow;
    }
  }

  /// obtiene las estadisticas completas de un invocador por nombre y region
  /// - realiza GET a 'riot/stats?summonerName={nombre}&region={region}'
  /// - retorna el mapa con las estadisticas dentro de 'stats'
  /// - si la respuesta es 404, lanza ApiException con mensaje 'invocador no encontrado'
  Future<Map<String, dynamic>> getSummonerStats(String summonerName, {String region = 'euw1'}) async {
    try {
      final response = await _apiClient.get('riot/stats?summonerName=$summonerName&region=$region');
      return response['data']['stats'];
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) {
        throw ApiException('invocador no encontrado');
      }
      rethrow;
    }
  }

  /// vincula la cuenta de LoL de un usuario actual usando nombre y region
  /// - realiza POST a 'riot/link' con body {'summonerName': nombre, 'region': region}
  /// - retorna el mapa con los datos de la cuenta vinculada dentro de 'lolAccount'
  /// - si la respuesta es 404, lanza ApiException con mensaje 'invocador no encontrado'
  Future<Map<String, dynamic>> linkSummonerAccount(String summonerName, {String region = 'euw1'}) async {
    try {
      final response = await _apiClient.post('riot/link', data: {
        'summonerName': summonerName,
        'region': region
      });
      return response['data']['lolAccount'];
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) {
        throw ApiException('invocador no encontrado');
      }
      rethrow;
    }
  }

  /// obtiene las estadisticas de la cuenta de LoL previamente vinculada
  /// - realiza GET a 'riot/linked-stats'
  /// - retorna el mapa con las estadisticas dentro de 'stats'
  /// - si la respuesta es 400, lanza ApiException con mensaje 'no hay cuenta de lol vinculada'
  Future<Map<String, dynamic>> getLinkedAccountStats() async {
    try {
      final response = await _apiClient.get('riot/linked-stats');
      return response['data']['stats'];
    } catch (e) {
      if (e is ApiException && e.statusCode == 400) {
        throw ApiException('no hay cuenta de lol vinculada');
      }
      rethrow;
    }
  }
}
