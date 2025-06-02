class Validators {
  /// valida un correo electrónico:
  /// - verifica que no esté vacío
  /// - verifica formato básico usando expresión regular
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'por favor, ingresa tu correo electrónico';
    }
    
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'por favor, ingresa un correo electrónico válido';
    }
    
    return null;
  }

  /// valida una contraseña:
  /// - verifica que no esté vacía
  /// - verifica que tenga al menos 6 caracteres
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'por favor, ingresa tu contraseña';
    }
    
    if (value.length < 6) {
      return 'la contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }

  /// valida que las contraseñas coincidan:
  /// - verifica confirmación no vacía
  /// - compara con la contraseña original
  static String? validatePasswordMatch(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'por favor, confirma tu contraseña';
    }
    
    if (value != password) {
      return 'las contraseñas no coinciden';
    }
    
    return null;
  }

  /// valida un nombre de usuario:
  /// - verifica que no esté vacío
  /// - verifica que tenga al menos 3 caracteres
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'por favor, ingresa un nombre de usuario';
    }
    
    if (value.length < 3) {
      return 'el nombre de usuario debe tener al menos 3 caracteres';
    }
    
    return null;
  }

  /// valida un campo requerido genérico:
  /// - recibe el valor y el nombre del campo para mensaje personalizado
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'por favor, ingresa $fieldName';
    }
    
    return null;
  }
}
