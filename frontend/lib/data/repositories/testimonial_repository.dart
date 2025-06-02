import '../../core/api/api_client.dart';
import '../models/testimonial_model.dart';

/// repositorio que gestiona las operaciones relacionadas con testimonios:
/// - obtiene lista de testimonios
/// - obtiene lista completa para admin
/// - obtiene estadisticas
/// - crea, aprueba y elimina testimonios
class TestimonialRepository {
  /// cliente HTTP para realizar peticiones a la API
  final ApiClient _apiClient;

  /// constructor que acepta un ApiClient opcional o crea uno por defecto
  TestimonialRepository({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? ApiClient();

  /// obtiene lista de testimonios aprobados (para vista publica)
  /// - llama a GET 'testimonials'
  /// - maneja diferentes estructuras de respuesta devolviendo lista vacia si no encaja
  Future<List<Testimonial>> getTestimonials() async {
    final response = await _apiClient.get('testimonials');
    
    // intentar extraer lista de testimonios del response
    List<dynamic>? testimonialsJson;
    if (response is List) {
      testimonialsJson = response;
    } else if (response is Map && response.containsKey('data') && response['data'] is List) {
      testimonialsJson = response['data'];
    } else {
      // en caso de estructura inesperada, mostrar log y retornar lista vacia
      print('unexpected response structure for getTestimonials: $response');
      return [];
    }
    
    if (testimonialsJson == null) return [];

    // mapear cada JSON a instancia de Testimonial
    return testimonialsJson.map((json) => Testimonial.fromJson(json)).toList();
  }

  /// obtiene lista completa de testimonios (para vista administrativa)
  /// - llama a GET 'testimonials/all'
  /// - maneja estructura similar a getTestimonials
  Future<List<Testimonial>> getAllTestimonialsAdmin() async {
    final response = await _apiClient.get('testimonials/all');
    
    List<dynamic>? testimonialsJson;
    if (response is List) {
      testimonialsJson = response;
    } else if (response is Map && response.containsKey('data') && response['data'] is List) {
      testimonialsJson = response['data'];
    } else {
      print('unexpected response structure for getAllTestimonialsAdmin: $response');
      return [];
    }
    
    if (testimonialsJson == null) return [];
    
    return testimonialsJson.map((json) => Testimonial.fromJson(json)).toList();
  }

  /// obtiene estadisticas de testimonios (total y calificacion media)
  /// - llama a GET 'testimonials/stats'
  /// - espera un Map<String, dynamic> como respuesta, lanza excepcion si no es asi
  Future<Map<String, dynamic>> getTestimonialStats() async {
    final response = await _apiClient.get('testimonials/stats');
    if (response is Map<String, dynamic>) {
      return response;
    } else {
      print('unexpected response format for getTestimonialStats: $response');
      throw Exception('failed to load testimonial stats: invalid response from server');
    }
  }

  /// crea un nuevo testimonio en el servidor
  /// - llama a POST 'testimonials' enviando los datos del Testimonial como JSON
  /// - como el backend devuelve directamente el objeto creado, verificar que sea un Map
  Future<Testimonial> createTestimonial(Testimonial testimonial) async {
    final response = await _apiClient.post(
      'testimonials',
      data: testimonial.toJson(),
    );
    
    if (response is Map<String, dynamic>) {
       return Testimonial.fromJson(response);
    } else {
       print('unexpected response format for createTestimonial: $response');
       throw Exception('failed to create testimonial: invalid response from server');
    }
  }

  /// aprueba un testimonio identificandolo por su id
  /// - verifica que el id no sea vacio, lanza excepcion si lo es
  /// - llama a PUT 'testimonials/{id}/approve'
  Future<void> approveTestimonial(String id) async {
    if (id.isEmpty) {
      throw Exception('testimonial id cannot be empty');
    }
    print('approving testimonial with id: $id');
    await _apiClient.put('testimonials/$id/approve');
  }

  /// elimina un testimonio por su id
  /// - verifica que el id no sea vacio, lanza excepcion si lo es
  /// - llama a DELETE 'testimonials/{id}'
  Future<void> deleteTestimonial(String id) async {
    if (id.isEmpty) {
      throw Exception('testimonial id cannot be empty');
    }
    print('deleting testimonial with id: $id');
    await _apiClient.delete('testimonials/$id');
  }
}
