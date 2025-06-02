import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../errors/api_exception.dart';
import '../utils/storage_util.dart';

class ApiClient {
  /*
    cliente HTTP y utilidad de almacenamiento:
    - _httpClient: instancia de http.Client para hacer peticiones
    - _storageUtil: instancia de StorageUtil para obtener token guardado
  */
  final http.Client _httpClient;
  final StorageUtil _storageUtil;

  /*
    constructor con parametros opcionales para inyectar dependencias (útil para tests):
    si no se proporcionan, se crean instancias por defecto
  */
  ApiClient({
    http.Client? httpClient,
    StorageUtil? storageUtil,
  })  : _httpClient = httpClient ?? http.Client(),
        _storageUtil = storageUtil ?? StorageUtil();

  /*
    métodos públicos para realizar peticiones HTTP:
    - get: obtiene datos de un endpoint
    - post: envía datos al endpoint
    - put: actualiza datos en el endpoint
    - delete: elimina datos en el endpoint
    todos delegan en _sendRequest
  */
  Future<dynamic> get(String endpoint) async {
    return _sendRequest('GET', endpoint);
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? data}) async {
    return _sendRequest('POST', endpoint, data: data);
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? data}) async {
    return _sendRequest('PUT', endpoint, data: data);
  }

  Future<dynamic> delete(String endpoint) async {
    return _sendRequest('DELETE', endpoint);
  }

  /*
    método interno que construye y envía la petición HTTP:
    - method: tipo de petición ('GET', 'POST', 'PUT', 'DELETE')
    - endpoint: ruta relativa a la API
    - data: datos opcionales para body en POST/PUT
    paso a paso:
    1. limpia la URL base y el endpoint para evitar dobles barras
    2. obtiene headers (incluye token si existe)
    3. realiza la petición correspondiente
    4. maneja la respuesta o lanza ApiException con mensajes adecuados
  */
  Future<dynamic> _sendRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    // asegurarse de que apiUrl no termine con '/' para evitar dobles barras
    final baseUrl = AppConstants.apiUrl.endsWith('/')
        ? AppConstants.apiUrl.substring(0, AppConstants.apiUrl.length - 1)
        : AppConstants.apiUrl;
    // eliminar '/' inicial del endpoint si lo tiene
    final cleanedEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

    final url = Uri.parse('$baseUrl/api/$cleanedEndpoint');
    final headers = await _getHeaders();

    http.Response response;

    try {
      if (method == 'GET') {
        response = await _httpClient.get(url, headers: headers);
      } else if (method == 'POST') {
        response = await _httpClient.post(
          url,
          headers: headers,
          body: json.encode(data),
        );
      } else if (method == 'PUT') {
        response = await _httpClient.put(
          url,
          headers: headers,
          body: json.encode(data),
        );
      } else if (method == 'DELETE') {
        response = await _httpClient.delete(url, headers: headers);
      } else {
        throw ApiException('método http no soportado: $method');
      }

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      // mejorar mensaje si el error parece relacionado con CORS o conexion
      if (e.toString().contains('xmlhttprequest error') ||
          e.toString().contains('cors') ||
          e.toString().contains('access-control-allow-origin')) {
        throw ApiException(
            'error de cors: no se puede conectar al servidor. verifica que el servidor esté ejecutándose y que cors esté configurado correctamente.');
      }
      throw ApiException('error de conexión: ${e.toString()}');
    }
  }

  /*
    método interno para obtener headers comunes:
    - 'Content-Type' y 'Accept' fijos en 'application/json'
    - si hay token guardado, agregar Authorization: Bearer <token>
  */
  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = await _storageUtil.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /*
    método interno para manejar la respuesta HTTP:
    - si statusCode entre 200 y 299: intenta decodificar JSON o retorna null si el body está vacío
    - si statusCode fuera de ese rango: intenta extraer 'message' y 'errors' del JSON de error
      o devuelve mensaje genérico con status y reasonPhrase si el body no es JSON
    - lanza ApiException con datos correspondientes
  */
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // si el body está vacío o solo espacios, retornar null
      if (response.body.trim().isEmpty) {
        return null;
      }
      try {
        final body = json.decode(response.body);
        return body;
      } catch (e) {
        // lanzar FormatException si no se puede decodificar JSON en cuerpo no vacío
        throw FormatException('failed to decode json response: $e');
      }
    } else {
      // manejar respuestas de error: intentar extraer 'message' y 'errors'
      String message = 'error desconocido';
      dynamic errors;
      try {
        final body = json.decode(response.body);
        message = body['message'] ?? message;
        errors = body['errors'];
      } catch (e) {
        // si no es JSON, usar status y reasonPhrase con el body crudo
        message =
            'error: ${response.statusCode} ${response.reasonPhrase ?? 'unknown error'}. response body: ${response.body}';
      }

      throw ApiException(
        message,
        statusCode: response.statusCode,
        errors: errors,
      );
    }
  }
}
