import 'package:flutter/foundation.dart';
import '../models/testimonial_model.dart';
import '../repositories/testimonial_repository.dart';

/// proveedor de estado que gestiona testimonios tanto para vista publica como administrativa
class TestimonialProvider extends ChangeNotifier {
  /// repositorio para interactuar con la api de testimonios
  final TestimonialRepository _repository;
  
  /// lista de testimonios aprobados para vista publica
  List<Testimonial> _testimonials = [];
  /// lista de todos los testimonios (aprobados o no) para vista administrativa
  List<Testimonial> _allTestimonials = [];
  /// indicador de carga para vista publica
  bool _isLoading = false;
  /// indicador de carga para vista administrativa
  bool _isAdminLoading = false;
  /// mensaje de error para vista publica
  String? _error;
  /// mensaje de error para vista administrativa
  String? _adminError;
  
  /// campos de estadisticas de testimonios
  int _totalApprovedTestimonials = 0;
  double _averageRating = 0.0;

  /// constructor que permite inyectar un repositorio de prueba o usa el repositorio por defecto
  TestimonialProvider({TestimonialRepository? repository})
      : _repository = repository ?? TestimonialRepository();

  // getters para exponer propiedades internas
  List<Testimonial> get testimonials => _testimonials;
  List<Testimonial> get allTestimonials => _allTestimonials;
  bool get isLoading => _isLoading;
  bool get isAdminLoading => _isAdminLoading;
  String? get error => _error;
  String? get adminError => _adminError;
  int get totalApprovedTestimonials => _totalApprovedTestimonials;
  double get averageRating => _averageRating;

  /// carga testimonios aprobados para vista publica
  Future<void> loadTestimonials() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('attempting to load approved testimonials...'); 
      final fetchedTestimonials = await _repository.getTestimonials();
      print('fetched ${fetchedTestimonials.length} testimonials for public view.');
      for (var t in fetchedTestimonials) {
        print('fetched testimonial id: ${t.id}, isApproved: ${t.isApproved}');
      }

      // filtra solo los aprobados
      _testimonials = fetchedTestimonials.where((t) => t.isApproved).toList();
      print('filtered to ${_testimonials.length} approved testimonials.');
      print('testimonials list state after filtering: ${_testimonials.map((t) => 'id: ${t.id}, isApproved: ${t.isApproved}').join(', ')}');
    } catch (e) {
      _error = 'error al cargar testimonios: $e';
      print('error cargando testimonios: $e');
      // fallback a datos locales de ejemplo, tambien filtra aprobados
      _testimonials = _getDefaultTestimonials().where((t) => t.isApproved).toList();
      print('loaded ${_testimonials.length} fallback approved testimonials.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// carga todos los testimonios para vista administrativa (incluye no aprobados)
  Future<void> loadAllTestimonialsAdmin() async {
    _isAdminLoading = true;
    _adminError = null;
    notifyListeners();

    try {
      _allTestimonials = await _repository.getAllTestimonialsAdmin();
    } catch (e) {
      _adminError = 'error al cargar todos los testimonios: $e';
      print('error cargando todos los testimonios (admin): $e');
      _allTestimonials = []; 
    } finally {
      _isAdminLoading = false;
      notifyListeners();
    }
  }
  
  /// carga estadisticas de testimonios (total y promedio)
  Future<void> loadTestimonialStats() async {
    try {
      final stats = await _repository.getTestimonialStats();
      _totalApprovedTestimonials = stats['totalTestimonials'] ?? 0;
      _averageRating = (stats['averageRating'] as num?)?.toDouble() ?? 0.0;
      notifyListeners();
    } catch (e) {
      print('error loading testimonial stats: $e');
      // opcional: asignar un mensaje de error para estadisticas
    }
  }

  /// agrega un nuevo testimonio (no se recarga vista publica hasta aprobacion)
  Future<bool> addTestimonial(Testimonial testimonial) async {
    try {
      await _repository.createTestimonial(testimonial);
      // no recarga loadTestimonials porque requiere aprobacion
      return true;
    } catch (e) {
      print('error al crear testimonio: $e');
      _error = 'error al crear testimonio: $e';
      notifyListeners();
      return false;
    }
  }

  /// aprueba un testimonio y recarga listas y estadisticas
  Future<bool> approveTestimonial(String id) async {
    print('attempting to approve testimonial with id: $id');
    if (id.isEmpty) {
      print('error: testimonial id is empty');
      _adminError = 'error al aprobar testimonio: id no válido';
      notifyListeners();
      return false;
    }

    try {
      await _repository.approveTestimonial(id);
      // recarga datos para ambas vistas y estadisticas
      await loadAllTestimonialsAdmin();
      await loadTestimonials();
      await loadTestimonialStats();
      return true;
    } catch (e) {
      _adminError = 'error al aprobar testimonio: $e';
      print('error al aprobar testimonio: $e');
      notifyListeners();
      return false;
    }
  }

  /// elimina un testimonio y recarga listas y estadisticas
  Future<bool> deleteTestimonial(String id) async {
    print('attempting to delete testimonial with id: $id');
    if (id.isEmpty) {
      print('error: testimonial id is empty');
      _adminError = 'error al eliminar testimonio: id no válido';
      notifyListeners();
      return false;
    }

    try {
      await _repository.deleteTestimonial(id);
      // recarga datos para ambas vistas y estadisticas
      await loadAllTestimonialsAdmin();
      await loadTestimonials();
      await loadTestimonialStats();
      return true;
    } catch (e) {
      _adminError = 'error al eliminar testimonio: $e';
      print('error al eliminar testimonio: $e');
      notifyListeners();
      return false;
    }
  }

  /// datos de ejemplo en caso de error en carga remota
  List<Testimonial> _getDefaultTestimonials() {
    return [
      Testimonial(
        id: '1',
        name: 'Carlos Rodríguez',
        avatarUrl: 'https://via.placeholder.com/100',
        comment: 'las sesiones de coaching me ayudaron a subir de plata a diamante en solo 2 meses. el coach identificó rápidamente mis errores y me dio estrategias claras para mejorar. increíble!',
        rating: 5.0,
        initialRank: 'silver II',
        currentRank: 'diamond IV',
        date: DateTime.now(),
        isApproved: true,
      ),
      Testimonial(
        id: '2',
        name: 'Laura Martínez',
        avatarUrl: 'https://via.placeholder.com/100',
        comment: 'excelente coach, muy paciente y explica todo de manera clara. mejoré mucho mi macro juego y ahora entiendo mejor cómo y cuándo rotar para ayudar a mi equipo. totalmente recomendado.',
        rating: 4.5,
        initialRank: 'gold IV',
        currentRank: 'platinum II',
        date: DateTime.now(),
        isApproved: true,
      ),
      // otros testimonios de ejemplo...
    ];
  }
}
