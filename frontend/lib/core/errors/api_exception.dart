// clase que representa una excepcion generica de la api:
// incluye mensaje, codigo de estado opcional y detalles de errores
class ApiException implements Exception {
  // mensaje de error descriptivo
  final String message;
  // codigo de estado HTTP que provoco el error (opcional)
  final int? statusCode;
  // detalles adicionales del error (opcional), puede ser cualquier estructura de datos
  final dynamic errors;

  // constructor que inicializa el mensaje y opcionalmente codigo y detalles
  ApiException(
    this.message, {
    this.statusCode,
    this.errors,
  });

  @override
  String toString() {
    // representa la excepcion como texto, incluyendo mensaje y codigo de estado
    return 'apiexception: $message (status code: $statusCode)';
  }
}
