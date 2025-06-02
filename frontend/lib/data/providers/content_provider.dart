import 'package:flutter/foundation.dart';
import '../models/content_model.dart';
import '../repositories/content_repository.dart';
import '../../core/errors/api_exception.dart';

/// proveedor de estado que gestiona la obtención y selección de contenido:
/// - lista de contenidos disponibles
/// - contenido seleccionado individualmente
/// - indicadores de carga y mensajes de error
class ContentProvider with ChangeNotifier {
  /// repositorio para interactuar con la API de contenido
  final ContentRepository _contentRepository;

  /// lista local de contenidos obtenidos
  List<Content> _contents = [];
  /// contenido seleccionado actualmente (por ejemplo, para ver detalles)
  Content? _selectedContent;
  /// indicador de carga para mostrar spinner o estado de espera
  bool _isLoading = false;
  /// mensaje de error en caso de que la petición falle
  String? _error;

  /// constructor que permite inyectar un repositorio custom (para tests) o usa el repositorio por defecto
  ContentProvider({
    ContentRepository? contentRepository,
  }) : _contentRepository = contentRepository ?? ContentRepository();

  // getters para exponer propiedades internas
  List<Content> get contents => _contents;
  Content? get selectedContent => _selectedContent;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// método para obtener contenidos filtrados por tipo, si es premium o por etiqueta:
  /// - marca el estado como cargando y limpia cualquier error previo
  /// - llama a getContents del repositorio con parámetros opcionales
  /// - si tiene éxito, actualiza la lista local y quita el estado de carga
  /// - si falla, captura el mensaje de ApiException o asigna mensaje genérico y quita estado de carga
  Future<void> fetchContents({
    String? type,
    bool? isPremium,
    String? tag,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _contents = await _contentRepository.getContents(
        type: type,
        isPremium: isPremium,
        tag: tag,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al cargar el contenido';
      }
      notifyListeners();
    }
  }

  /// método para obtener los contenidos más recientes con un límite por defecto:
  /// - marca el estado como cargando y limpia cualquier error previo
  /// - llama a getLatestContents(con límite) en el repositorio
  /// - si tiene éxito, actualiza la lista local y quita estado de carga
  /// - si falla, captura mensaje de ApiException o asigna mensaje genérico
  Future<void> fetchLatestContents({int limit = 5}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _contents = await _contentRepository.getLatestContents(limit: limit);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al cargar el contenido reciente';
      }
      notifyListeners();
    }
  }

  /// método para obtener un contenido específico por su id:
  /// - marca el estado como cargando y limpia error previo
  /// - llama a getContentById del repositorio
  /// - si tiene éxito, almacena el contenido en _selectedContent y quita estado de carga
  /// - si falla, captura mensaje de ApiException o asigna mensaje genérico
  Future<void> fetchContentById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedContent = await _contentRepository.getContentById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al cargar el contenido';
      }
      notifyListeners();
    }
  }

  /// método para buscar contenidos por texto:
  /// - marca estado de carga y limpia error previo
  /// - llama a searchContents del repositorio con el query
  /// - si éxito, actualiza lista local y quita estado de carga
  /// - si falla, captura mensaje de ApiException o asigna mensaje genérico
  Future<void> searchContents(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _contents = await _contentRepository.searchContents(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error al buscar contenido';
      }
      notifyListeners();
    }
  }

  /// método para seleccionar un contenido de la lista:
  /// - asigna el objeto Content a _selectedContent y notifica listeners para actualizar UI
  void selectContent(Content content) {
    _selectedContent = content;
    notifyListeners();
  }
}
