import 'package:flutter/foundation.dart';
import '../models/service_model.dart';
import '../repositories/service_repository.dart';
import '../../core/errors/api_exception.dart';

/// proveedor de estado que gestiona la obtencion y seleccion de servicios:
/// - lista de servicios disponibles
/// - servicio seleccionado individualmente
/// - indicadores de carga y mensajes de error
class ServiceProvider with ChangeNotifier {
  /// repositorio para interactuar con la API de servicios
  final ServiceRepository _serviceRepository;
  
  /// lista local de servicios obtenidos
  List<Service> _services = [];
  /// servicio seleccionado actualmente (por ejemplo, para ver detalles)
  Service? _selectedService;
  /// indicador de carga para mostrar spinner o estado de espera
  bool _isLoading = false;
  /// mensaje de error en caso de que la peticion falle
  String? _error;
  
  /// constructor que permite inyectar un repositorio custom (para tests) o usa el repositorio por defecto
  ServiceProvider({
    ServiceRepository? serviceRepository,
  }) : _serviceRepository = serviceRepository ?? ServiceRepository();
  
  // getters para exponer propiedades internas
  List<Service> get services => _services;
  Service? get selectedService => _selectedService;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// metodo para obtener servicios filtrados por tipo, si son populares o activos:
  /// - marca el estado como cargando y limpia cualquier error previo
  /// - llama a getServices del repositorio con parametros opcionales
  /// - si tiene exito, actualiza la lista local y quita el estado de carga
  /// - si falla, captura el mensaje de ApiException o asigna mensaje generico y quita estado de carga
  Future<void> fetchServices({
    String? type,
    bool? isPopular,
    bool? isActive,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _services = await _serviceRepository.getServices(
        type: type,
        isPopular: isPopular,
        isActive: isActive,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al cargar los servicios';
      }
      notifyListeners();
    }
  }
  
  /// metodo para obtener un servicio especifico por su id:
  /// - marca el estado como cargando y limpia cualquier error previo
  /// - llama a getServiceById del repositorio
  /// - si tiene exito, guarda el servicio en _selectedService y quita estado de carga
  /// - si falla, captura mensaje de ApiException o asigna mensaje generico y quita estado de carga
  Future<void> fetchServiceById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _selectedService = await _serviceRepository.getServiceById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al cargar el servicio';
      }
      notifyListeners();
    }
  }
  
  /// metodo para seleccionar manualmente un servicio de la lista local:
  /// - asigna el objeto Service a _selectedService y notifica listeners para actualizar UI
  void selectService(Service service) {
    _selectedService = service;
    notifyListeners();
  }
}
