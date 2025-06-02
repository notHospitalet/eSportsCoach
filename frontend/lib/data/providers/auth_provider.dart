import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../../core/errors/api_exception.dart';

/*
  enumeracion que define los posibles estados de autenticacion:
  - initial: estado inicial antes de verificar usuario
  - authenticated: usuario autenticado correctamente
  - unauthenticated: usuario no autenticado o sesión cerrada
  - authenticating: en proceso de autenticacion (login o registro)
*/
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
}

/*
  proveedor de estado que maneja la autenticacion del usuario:
  - usa ChangeNotifier para notificar cambios en la interfaz
  - interactua con AuthRepository para realizar operaciones de login, registro y logout
  - expone el estado actual, el usuario, mensaje de error y si esta autenticado
*/
class AuthProvider with ChangeNotifier {
  // repositorio para llamadas a la API de autenticacion
  final AuthRepository _authRepository;

  // estado interno de autenticacion
  AuthStatus _status = AuthStatus.initial;
  // representacion del usuario actualmente autenticado (null si no hay)
  User? _user;
  // mensaje de error al intentar autenticar o registrar (null si no hay)
  String? _error;

  /*
    constructor que acepta un AuthRepository opcional (para inyectar en tests):
    - si no se proporciona, crea una instancia por defecto
    - al inicializar, verifica si ya hay un usuario logueado
  */
  AuthProvider({
    AuthRepository? authRepository,
  }) : _authRepository = authRepository ?? AuthRepository() {
    _checkCurrentUser();
  }

  // getters para exponer el estado interno
  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /*
    metodo interno que verifica en el repositorio si ya hay un usuario logueado:
    - si isLoggedIn() es true, obtiene el usuario actual y cambia el estado a authenticated
    - si no, cambia el estado a unauthenticated
    - captura excepciones y asume usuario no autenticado en caso de error
    - notifica a los listeners para actualizar la interface
  */
  Future<void> _checkCurrentUser() async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        _user = await _authRepository.getCurrentUser();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /*
    metodo que realiza el proceso de login:
    - recibe email y password
    - cambia estado a authenticating y limpia error previo
    - intenta llamar a authRepository.login
    - si tiene exito, asigna el usuario retornado, cambia estado a authenticated y retorna true
    - si falla, asigna estado a unauthenticated, guarda mensaje de error (si es ApiException usa su mensaje, sino un mensaje generico) y retorna false
    - notifica a los listeners en cada cambio de estado
  */
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepository.login(email, password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error de autenticación';
      }
      notifyListeners();
      return false;
    }
  }

  /*
    metodo que realiza el proceso de registro:
    - recibe username, email y password
    - cambia estado a authenticating y limpia error previo
    - intenta llamar a authRepository.register
    - si tiene exito, asigna el usuario retornado, cambia estado a authenticated y retorna true
    - si falla, asigna estado a unauthenticated, guarda mensaje de error (si es ApiException usa su mensaje, sino un mensaje generico) y retorna false
    - notifica a los listeners en cada cambio de estado
  */
  Future<bool> register(String username, String email, String password) async {
    _status = AuthStatus.authenticating;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepository.register(username, email, password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = 'error de registro';
      }
      notifyListeners();
      return false;
    }
  }

  /*
    metodo que realiza el logout del usuario:
    - llama a authRepository.logout para limpiar token y datos locales
    - asigna _user a null y estado a unauthenticated
    - notifica a los listeners para actualizar la interfaz
  */
  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
