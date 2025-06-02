import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constants.dart';

/*
  clase que gestiona el tema de la aplicacion:
  - obtiene y guarda el modo de tema en shared preferences
  - provee metodos para consultar colores segun el tema actual
*/
class ThemeUtil {
  /*
    metodo asincrono que obtiene el modo de tema guardado:
    - lee la cadena desde shared preferences usando la clave definida en AppConstants
    - retorna ThemeMode.light, ThemeMode.dark o ThemeMode.system segun el valor almacenado
  */
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(AppConstants.themeKey);

    if (themeString == 'light') {
      return ThemeMode.light;
    } else if (themeString == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  /*
    metodo asincrono que guarda el modo de tema seleccionado:
    - recibe un ThemeMode
    - convierte el enum a cadena ('light', 'dark' o 'system')
    - almacena la cadena en shared preferences bajo la clave definida en AppConstants
    - retorna true si la operacion fue exitosa
  */
  static Future<bool> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    String themeString;

    switch (themeMode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      default:
        themeString = 'system';
    }

    return prefs.setString(AppConstants.themeKey, themeString);
  }

  /*
    metodo que verifica si el tema actual del contexto es oscuro:
    - usa Theme.of(context).brightness para determinar si es dark
    - retorna true si el brillo es dark, false en caso contrario
  */
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /*
    metodo que obtiene el color de fondo segun el tema:
    - si es modo oscuro, retorna un color oscuro
    - si es modo claro, retorna un color claro
  */
  static Color getBackgroundColor(BuildContext context) {
    return isDarkMode(context)
        ? const Color(0xFF121212)
        : const Color(0xFFF2F2F7);
  }

  /*
    metodo que obtiene el color de la tarjeta segun el tema:
    - si es modo oscuro, retorna un gris oscuro
    - si es modo claro, retorna blanco
  */
  static Color getCardColor(BuildContext context) {
    return isDarkMode(context)
        ? const Color(0xFF2C2C2E)
        : Colors.white;
  }

  /*
    metodo que obtiene el color de texto secundario segun el tema:
    - si es modo oscuro, retorna un blanco con opacidad
    - si es modo claro, retorna un negro con opacidad
  */
  static Color getSecondaryTextColor(BuildContext context) {
    return isDarkMode(context)
        ? Colors.white70
        : Colors.black54;
  }
}
