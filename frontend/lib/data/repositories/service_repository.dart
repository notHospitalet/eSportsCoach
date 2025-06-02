import '../../core/api/api_client.dart';
import '../models/service_model.dart';

/// repositorio que gestiona las operaciones relacionadas con los servicios:
/// - obtencion de lista de servicios con filtros
/// - obtencion de un servicio por id
/// - creacion, actualizacion y eliminacion de servicios
class ServiceRepository {
  /// cliente HTTP para realizar peticiones a la API
  final ApiClient _apiClient;

  /// constructor que acepta un ApiClient opcional o crea uno por defecto
  ServiceRepository({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? ApiClient();

  /// obtiene la lista de servicios con filtros opcionales:
  /// - type: filtra por tipo de servicio (individual, monthly, etc.)
  /// - isPopular: filtra por si son populares
  /// - isActive: filtra por si están activos
  ///
  /// Construye el query string a partir de los parámetros proporcionados
  /// y llama a GET 'services{?params}'. Luego mapea el JSON de respuesta
  /// a una lista de instancias de Service.
  Future<List<Service>> getServices({
    String? type,
    bool? isPopular,
    bool? isActive,
  }) async {
    // construir parámetros de consulta
    final queryParams = <String, String>{};
    if (type != null) queryParams['type'] = type;
    if (isPopular != null) queryParams['isPopular'] = isPopular.toString();
    if (isActive != null) queryParams['isActive'] = isActive.toString();

    // generar cadena de consulta a partir del mapa de parámetros
    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';

    // realizar petición GET a 'services{?params}'
    final response = await _apiClient.get('services$queryString');
    final List<dynamic> servicesJson = response['data']['services'];

    // mapear cada JSON a instancia de Service
    return servicesJson.map((json) => Service.fromJson(json)).toList();
  }

  /// obtiene un servicio específico por su identificador:
  /// - llama a GET 'services/{id}'
  /// - parsea el JSON de respuesta a una instancia de Service
  Future<Service> getServiceById(String id) async {
    final response = await _apiClient.get('services/$id');
    return Service.fromJson(response['data']['service']);
  }

  /// crea un nuevo servicio en el servidor:
  /// - llama a POST 'services' enviando el objeto Service como JSON
  /// - retorna la instancia de Service creada a partir de la respuesta
  Future<Service> createService(Service service) async {
    final response = await _apiClient.post(
      'services',
      data: service.toJson(),
    );
    return Service.fromJson(response['data']['service']);
  }

  /// actualiza un servicio existente:
  /// - llama a PUT 'services/{id}' enviando el Service actualizado como JSON
  /// - retorna la instancia de Service actualizada a partir de la respuesta
  Future<Service> updateService(String id, Service service) async {
    final response = await _apiClient.put(
      'services/$id',
      data: service.toJson(),
    );
    return Service.fromJson(response['data']['service']);
  }

  /// elimina un servicio por su identificador:
  /// - llama a DELETE 'services/{id}'
  Future<void> deleteService(String id) async {
    await _apiClient.delete('services/$id');
  }
}
