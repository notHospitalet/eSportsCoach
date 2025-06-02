import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../repositories/booking_repository.dart';
import '../../core/errors/api_exception.dart';

/// clase que gestiona el estado de las reservas y notifica cambios a la interfaz
class BookingProvider with ChangeNotifier {
  /// repositorio para interactuar con la api de reservas
  final BookingRepository _bookingRepository;
  
  /// lista local de reservas del usuario
  List<Booking> _bookings = [];
  /// indicador de carga para mostrar spinner o estado de espera
  bool _isLoading = false;
  /// mensaje de error cuando ocurre algun problema en la peticion
  String? _error;
  
  /// constructor que permite inyectar un repositorio custom (para tests) o usa el repositorio por defecto
  BookingProvider({
    BookingRepository? bookingRepository,
  }) : _bookingRepository = bookingRepository ?? BookingRepository();
  
  /// getters para exponer propiedades internas
  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// metodo para obtener las reservas del usuario
  /// - cambia el estado a cargando
  /// - llama al repositorio para obtener datos
  /// - si tiene exito, actualiza la lista y quita el estado de carga
  /// - si falla, captura el error y guarda mensaje para mostrar en la ui
  Future<void> fetchUserBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _bookings = await _bookingRepository.getUserBookings();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al cargar las reservas';
      }
      notifyListeners();
    }
  }
  
  /// metodo para crear una nueva reserva
  /// - muestra indicador de carga
  /// - envia la reserva al repositorio
  /// - si tiene exito, agrega la reserva retornada a la lista local
  /// - si falla, captura el error y guarda mensaje para la ui
  Future<bool> createBooking(Booking booking) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final newBooking = await _bookingRepository.createBooking(booking);
      _bookings.add(newBooking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al crear la reserva';
      }
      notifyListeners();
      return false;
    }
  }
  
  /// metodo para cancelar una reserva existente
  /// - marca el estado de carga
  /// - llama al repositorio para cancelar la reserva en el servidor
  /// - si tiene exito, actualiza el estado de esa reserva en la lista local a 'cancelled'
  /// - si falla, captura el error y guarda mensaje para la ui
  Future<bool> cancelBooking(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _bookingRepository.cancelBooking(id);
      
      // actualizar el estado de la reserva en la lista local
      final index = _bookings.indexWhere((booking) => booking.id == id);
      if (index != -1) {
        final booking = _bookings[index];
        final updatedBooking = Booking(
          id: booking.id,
          userId: booking.userId,
          serviceId: booking.serviceId,
          coachId: booking.coachId,
          date: booking.date,
          status: BookingStatus.cancelled,
          notes: booking.notes,
          paymentStatus: booking.paymentStatus,
          paymentId: booking.paymentId,
          amount: booking.amount,
          createdAt: booking.createdAt,
        );
        _bookings[index] = updatedBooking;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al cancelar la reserva';
      }
      notifyListeners();
      return false;
    }
  }
}
