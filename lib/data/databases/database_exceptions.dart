// file: database_exceptions.dart
class DatabaseException implements Exception {
  final String message;
  final Object? cause;

  DatabaseException(this.message, {this.cause});

  @override
  String toString() =>
      'DatabaseException: $message${cause != null ? ' (Caused by: $cause)' : ''}';
}

class UserCreationException extends DatabaseException {
  UserCreationException(super.message, {super.cause});
}

class AddictionCreationException extends DatabaseException {
  AddictionCreationException(super.message, {super.cause});
}
