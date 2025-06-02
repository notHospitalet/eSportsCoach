import 'package:flutter/foundation.dart';
import '../repositories/riot_repository.dart';
import '../../core/errors/api_exception.dart';

/// proveedor de estado para interaccion con la api de Riot:
/// gestiona busqueda de invocador, obtencion de estadisticas y vinculacion de cuenta
enum RiotStatus {
  initial,
  loading,
  success,
  error,
}

class RiotProvider with ChangeNotifier {
  /// repositorio que realiza las peticiones HTTP a la api de Riot
  final RiotRepository _riotRepository;

  /// estado interno del proveedor (inicial, cargando, exitoso o error)
  RiotStatus _status = RiotStatus.initial;
  /// datos basicos del invocador obtenidos al buscar por nombre
  Map<String, dynamic>? _summonerData;
  /// estadisticas completas del invocador (pueden ser de cuenta buscada o vinculada)
  Map<String, dynamic>? _summonerStats;
  /// informacion de la cuenta de LoL vinculada al usuario actual
  Map<String, dynamic>? _linkedAccount;
  /// mensaje de error en caso de fallo
  String? _error;

  /// constructor que acepta un repositorio opcional (para inyectar mocks en tests) o usa un repositorio por defecto
  RiotProvider({
    RiotRepository? riotRepository,
  }) : _riotRepository = riotRepository ?? RiotRepository();

  /// getters para exponer el estado y los datos al exterior
  RiotStatus get status => _status;
  Map<String, dynamic>? get summonerData => _summonerData;
  Map<String, dynamic>? get summonerStats => _summonerStats;
  Map<String, dynamic>? get linkedAccount => _linkedAccount;
  String? get error => _error;

  /// sección: busqueda de invocador por nombre
  /// - cambia estado a loading, limpia errores previos y notifica
  /// - llama al repositorio para buscar por nombre y region
  /// - en exito, guarda datos y cambia estado a success
  /// - en fallo, captura ApiException o asigna mensaje generico y cambia estado a error
  Future<bool> searchSummoner(String summonerName, {String region = 'euw1'}) async {
    _status = RiotStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _summonerData = await _riotRepository.searchSummoner(summonerName, region: region);
      _status = RiotStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = RiotStatus.error;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al buscar invocador';
      }
      notifyListeners();
      return false;
    }
  }

  /// sección: obtencion de estadisticas completas de un invocador
  /// - similar a searchSummoner, pero almacena resultados en _summonerStats
  Future<bool> getSummonerStats(String summonerName, {String region = 'euw1'}) async {
    _status = RiotStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _summonerStats = await _riotRepository.getSummonerStats(summonerName, region: region);
      _status = RiotStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = RiotStatus.error;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al obtener estadísticas';
      }
      notifyListeners();
      return false;
    }
  }

  /// sección: vinculacion de cuenta de LoL al usuario actual
  /// - almacena datos de la cuenta vinculada en _linkedAccount
  Future<bool> linkSummonerAccount(String summonerName, {String region = 'euw1'}) async {
    _status = RiotStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _linkedAccount = await _riotRepository.linkSummonerAccount(summonerName, region: region);
      _status = RiotStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = RiotStatus.error;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al vincular cuenta';
      }
      notifyListeners();
      return false;
    }
  }

  /// sección: obtencion de estadisticas de la cuenta vinculada
  /// - reutiliza _summonerStats para almacenar las estadisticas de la cuenta ya vinculada
  Future<bool> getLinkedAccountStats() async {
    _status = RiotStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _summonerStats = await _riotRepository.getLinkedAccountStats();
      _status = RiotStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = RiotStatus.error;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al obtener estadísticas';
      }
      notifyListeners();
      return false;
    }
  }

  /// sección: limpieza de datos internos
  /// - resetea summonerData, summonerStats, estado y error a valores iniciales
  void clearData() {
    _summonerData = null;
    _summonerStats = null;
    _status = RiotStatus.initial;
    _error = null;
    notifyListeners();
  }
}
