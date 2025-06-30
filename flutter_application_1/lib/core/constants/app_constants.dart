class AppConstants {
  static const String appName = 'Gestión de Estado Demo';
  static const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';
  
  // Configuración de timeout
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Mensajes de error
  static const String networkError = 'Error de conexión';
  static const String unknownError = 'Error desconocido';
  static const String timeoutError = 'Tiempo de espera agotado';
}
