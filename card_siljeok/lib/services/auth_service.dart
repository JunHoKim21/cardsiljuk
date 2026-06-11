// Conditional import for platform-specific AuthService implementation


// Re-export AuthService class
export 'auth_service_impl.dart' if (dart.library.html) 'auth_service_stub.dart';
