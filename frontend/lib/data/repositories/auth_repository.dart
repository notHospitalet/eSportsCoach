import '../../core/api/api_client.dart';
import '../../core/utils/storage_util.dart';
import '../models/user_model.dart';

/// repositorio encargado de gestionar las operaciones de autenticacion:
/// - login
/// - registro
/// - obtencion de usuario actual
/// - verificacion de sesion activa
/// - logout
class AuthRepository {
  final ApiClient _apiClient;
  final StorageUtil _storageUtil;

  /// constructor que permite inyectar un cliente http y utilidad de almacenamiento,
  /// o usar las instancias por defecto si no se proporcionan
  AuthRepository({
    ApiClient? apiClient,
    StorageUtil? storageUtil,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageUtil = storageUtil ?? StorageUtil();

  /// metodo para iniciar sesion:
  /// - realiza peticion POST a 'auth/login' con email y password
  /// - espera recibir datos de usuario y token en la respuesta
  /// - guarda token y datos del usuario en almacenamiento local
  /// - retorna el objeto User creado a partir del json de respuesta
  Future<User> login(String email, String password) async {
    final response = await _apiClient.post('auth/login', data: {
      'email': email,
      'password': password,
    });

    // parseo de datos de usuario y token
    final user = User.fromJson(response['data']['user']);
    final token = response['data']['token'];

    // guardar token y usuario en shared preferences
    await _storageUtil.setToken(token);
    await _storageUtil.setUser(user);

    return user;
  }

  /// metodo para registrar un nuevo usuario:
  /// - realiza peticion POST a 'auth/register' con username, email y password
  /// - espera recibir datos de usuario y token en la respuesta
  /// - guarda token y datos del usuario en almacenamiento local
  /// - retorna el objeto User creado a partir del json de respuesta
  Future<User> register(String username, String email, String password) async {
    final response = await _apiClient.post('auth/register', data: {
      'username': username,
      'email': email,
      'password': password,
    });

    // parseo de datos de usuario y token
    final user = User.fromJson(response['data']['user']);
    final token = response['data']['token'];

    // guardar token y usuario en shared preferences
    await _storageUtil.setToken(token);
    await _storageUtil.setUser(user);

    return user;
  }

  /// metodo para obtener el usuario actual desde almacenamiento local:
  /// - retorna null si no hay usuario guardado
  Future<User?> getCurrentUser() async {
    return await _storageUtil.getUser();
  }

  /// metodo para verificar si existe un token guardado:
  /// - retorna true si el token no es null
  Future<bool> isLoggedIn() async {
    final token = await _storageUtil.getToken();
    return token != null;
  }

  /// metodo para cerrar sesion:
  /// - elimina token y datos del usuario del almacenamiento local
  Future<void> logout() async {
    await _storageUtil.removeToken();
    await _storageUtil.removeUser();
  }
}
