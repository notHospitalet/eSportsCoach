import 'package:flutter/material.dart';
import '../models/user_preferences_model.dart';
import '../repositories/user_preferences_repository.dart';

/// proveedor de estado que gestiona las preferencias de usuario:
/// - carga y actualiza preferencias desde el repositorio
/// - maneja estado de carga y errores
class UserPreferencesProvider with ChangeNotifier {
  // instancia del repositorio para acceder a la API de preferencias
  final UserPreferencesRepository _repository = UserPreferencesRepository();
  
  // objeto que contiene las preferencias del usuario actual
  UserPreferences? _preferences;
  // indicador de carga para mostrar spinner o estado de espera
  bool _isLoading = false;
  // mensaje de error en caso de fallo en la carga o actualizacion
  String? _error;

  // getters para exponer propiedades internas
  UserPreferences? get preferences => _preferences;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// metodo para cargar las preferencias del usuario:
  /// - marca estado de carga y limpia errores previos
  /// - llama al repositorio para obtener datos
  /// - si exito, guarda preferencias y muestra en consola
  /// - si falla, captura el error y guarda mensaje
  /// - al finalizar, quita indicador de carga y notifica listeners
  Future<void> loadPreferences() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _preferences = await _repository.getPreferences();
      print("preferencias cargadas: ${_preferences?.toJson()}");
    } catch (e) {
      print("error al cargar preferencias: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// metodo para actualizar las preferencias del usuario:
  /// - recibe campos opcionales a actualizar (liga, division, riotId, rol y campeones favoritos)
  /// - marca estado de carga y limpia errores previos
  /// - llama al repositorio para enviar cambios
  /// - si exito, guarda las preferencias retornadas y muestra en consola
  /// - si falla, captura error y guarda mensaje
  /// - siempre notifica listeners antes y despues de la operacion
  Future<bool> updatePreferences({
    String? tier,
    String? division,
    String? riotId,
    String? mainRole,
    List<String>? favoriteChampions,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print("actualizando preferencias: tier=$tier, division=$division, riotId=$riotId, mainRole=$mainRole, favoriteChampions=$favoriteChampions");
      
      final updatedPreferences = await _repository.updatePreferences(
        tier: tier,
        division: division,
        riotId: riotId,
        mainRole: mainRole,
        favoriteChampions: favoriteChampions,
      );
      
      _preferences = updatedPreferences;
      print("preferencias actualizadas: ${_preferences?.toJson()}");
      notifyListeners();
      return true;
    } catch (e) {
      print("error al actualizar preferencias: $e");
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// metodo para limpiar el mensaje de error:
  /// - asigna null a _error y notifica listeners
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
