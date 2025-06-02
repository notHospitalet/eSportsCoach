import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_preferences_model.dart';
import '../../core/utils/storage_util.dart';
import '../../config/constants.dart'; // Importar constantes

/// repositorio que gestiona las operaciones relacionadas con las preferencias de usuario:
/// - obtener preferencias actuales
/// - actualizar preferencias
class UserPreferencesRepository {
  /// URL base de la API (ajustar según entorno)
  final String baseUrl = AppConstants.apiUrl; // Usar la constante centralizada
  /// utilidad para acceder a token y usuario almacenados localmente
  final StorageUtil _storageUtil = StorageUtil();

  /// método interno que obtiene los headers necesarios para peticiones autenticadas:
  /// - incluye 'Content-Type': 'application/json'
  /// - agrega cabecera 'Authorization' con el token Bearer si existe
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageUtil.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// obtiene las preferencias del usuario actual desde el endpoint '/user/profile'
  /// - construye headers con token
  /// - realiza GET a '$baseUrl/user/profile'
  /// - decodifica la respuesta JSON
  /// - si statusCode es 200 y 'success' es true, parsea 'preferences' a UserPreferences
  /// - en caso contrario, lanza excepción con mensaje de error del servidor
  Future<UserPreferences> getPreferences() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: headers,
      );
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        return UserPreferences.fromJson(responseData['preferences']);
      } else {
        throw Exception(responseData['message'] ?? 'error al cargar las preferencias');
      }
    } catch (e) {
      throw Exception('error de conexión: $e');
    }
  }

  /// actualiza las preferencias del usuario en el endpoint '/user/profile'
  /// - construye headers con token
  /// - crea mapa 'data' solo con los campos no nulos (tier, division, riotId, mainRole, favoriteChampions)
  /// - realiza PUT a '$baseUrl/user/profile' con body JSON de 'data'
  /// - decodifica la respuesta JSON
  /// - si statusCode es 200 y 'success' es true, parsea 'preferences' retornadas a UserPreferences
  /// - en caso contrario, lanza excepción con mensaje de error del servidor
  Future<UserPreferences> updatePreferences({
    String? tier,
    String? division,
    String? riotId,
    String? mainRole,
    List<String>? favoriteChampions,
  }) async {
    try {
      final headers = await _getHeaders();
      final data = <String, dynamic>{};
      
      if (tier != null) data['tier'] = tier;
      if (division != null) data['division'] = division;
      if (riotId != null) data['riotId'] = riotId;
      if (mainRole != null) data['mainRole'] = mainRole;
      if (favoriteChampions != null) data['favoriteChampions'] = favoriteChampions;

      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: headers,
        body: json.encode(data),
      );
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        return UserPreferences.fromJson(responseData['preferences']);
      } else {
        throw Exception(responseData['message'] ?? 'error al actualizar las preferencias');
      }
    } catch (e) {
      throw Exception('error de conexión: $e');
    }
  }
}
