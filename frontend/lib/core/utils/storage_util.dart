import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constants.dart';
import '../../data/models/user_model.dart';

/*
  clase que gestiona el almacenamiento local usando SharedPreferences:
  - guarda, obtiene y elimina token de autenticacion
  - guarda, obtiene y elimina datos de usuario serializados en JSON
  - guarda y obtiene el tema seleccionado
  - permite limpiar todo el almacenamiento
*/
class StorageUtil {
  // getter interno que obtiene la instancia de SharedPreferences de forma asíncrona
  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // ----------------------------------------
  // Token
  // ----------------------------------------

  /*
    obtiene el token guardado en SharedPreferences usando la clave definida en AppConstants
    retorna null si no existe token almacenado
  */
  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.tokenKey);
  }

  /*
    guarda el token en SharedPreferences usando la clave definida en AppConstants
    retorna true si la operación fue exitosa
  */
  Future<bool> setToken(String token) async {
    final prefs = await _prefs;
    return prefs.setString(AppConstants.tokenKey, token);
  }

  /*
    elimina el token almacenado en SharedPreferences usando la clave definida en AppConstants
    retorna true si la operación fue exitosa
  */
  Future<bool> removeToken() async {
    final prefs = await _prefs;
    return prefs.remove(AppConstants.tokenKey);
  }

  // ----------------------------------------
  // User
  // ----------------------------------------

  /*
    obtiene el objeto User guardado en SharedPreferences:
    - lee el JSON almacenado bajo la clave definida en AppConstants
    - si no existe, retorna null
    - si existe, decodifica el JSON y crea un User usando User.fromJson
  */
  Future<User?> getUser() async {
    final prefs = await _prefs;
    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson == null) return null;
    return User.fromJson(json.decode(userJson));
  }

  /*
    guarda el objeto User en SharedPreferences:
    - serializa el User a JSON usando user.toJson()
    - almacena la cadena JSON bajo la clave definida en AppConstants
    - retorna true si la operación fue exitosa
  */
  Future<bool> setUser(User user) async {
    final prefs = await _prefs;
    return prefs.setString(AppConstants.userKey, json.encode(user.toJson()));
  }

  /*
    elimina los datos del usuario almacenados en SharedPreferences bajo la clave definida en AppConstants
    retorna true si la operación fue exitosa
  */
  Future<bool> removeUser() async {
    final prefs = await _prefs;
    return prefs.remove(AppConstants.userKey);
  }

  // ----------------------------------------
  // Theme
  // ----------------------------------------

  /*
    obtiene el tema guardado en SharedPreferences usando la clave definida en AppConstants
    retorna null si no existe tema almacenado
  */
  Future<String?> getTheme() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.themeKey);
  }

  /*
    guarda la cadena que representa el tema en SharedPreferences bajo la clave definida en AppConstants
    retorna true si la operación fue exitosa
  */
  Future<bool> setTheme(String theme) async {
    final prefs = await _prefs;
    return prefs.setString(AppConstants.themeKey, theme);
  }

  // ----------------------------------------
  // Clear all
  // ----------------------------------------

  /*
    borra todas las entradas almacenadas en SharedPreferences
    retorna true si la operación fue exitosa
  */
  Future<bool> clearAll() async {
    final prefs = await _prefs;
    return prefs.clear();
  }
}
