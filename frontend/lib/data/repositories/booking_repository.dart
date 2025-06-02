import '../../core/api/api_client.dart';
import '../models/booking_model.dart';

/// repositorio que gestiona las operaciones relacionadas con las reservas (bookings)
class BookingRepository {
  /// cliente http que se encarga de hacer las peticiones a la api
  final ApiClient _apiClient;

  /// constructor que permite inyectar un ApiClient custom o usar el predeterminado
  BookingRepository({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? ApiClient();

  /// obtiene la lista de reservas del usuario actual
  /// - llama a GET 'bookings/user'
  /// - parsea la respuesta JSON en una lista de objetos Booking
  Future<List<Booking>> getUserBookings() async {
    final response = await _apiClient.get('bookings/user');
    final List<dynamic> bookingsJson = response['data']['bookings'];
    return bookingsJson.map((json) => Booking.fromJson(json)).toList();
  }

  /// crea una nueva reserva en el servidor
  /// - llama a POST 'bookings' enviando los datos de la reserva como JSON
  /// - retorna el objeto Booking creado a partir de la respuesta
  Future<Booking> createBooking(Booking booking) async {
    final response = await _apiClient.post(
      'bookings',
      data: booking.toJson(),
    );
    return Booking.fromJson(response['data']['booking']);
  }

  /// actualiza el estado de una reserva existente
  /// - llama a PUT 'bookings/{id}' enviando el nuevo estado en el body
  /// - retorna el objeto Booking actualizado según la respuesta
  Future<Booking> updateBooking(String id, String status) async {
    final response = await _apiClient.put(
      'bookings/$id',
      data: {'status': status},
    );
    return Booking.fromJson(response['data']['booking']);
  }

  /// cancela una reserva en el servidor
  /// - llama a PUT 'bookings/{id}/cancel' (no requiere body adicional)
  Future<void> cancelBooking(String id) async {
    await _apiClient.put(
      'bookings/$id/cancel',
      data: {},
    );
  }
}
