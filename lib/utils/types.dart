// lib/utils/types.dart

/// Place-related types
enum PlaceType { attraction, restaurant }

/// Transportation-related types
enum TransportationType { walking, publicTransport, taxi, other }

/// Message-related types
enum MessageRole {
  user,
  assistant,
  system,
}

/// Custom type definitions for commonly used structures
typedef Coordinates = Map<String, double>;
typedef JsonMap = Map<String, dynamic>;
typedef Metadata = Map<String, dynamic>;

/// Constants for type conversion
class TypeConstants {
  static const defaultCoordinates = {'lat': 0.0, 'lng': 0.0};
  static const defaultMetadata = <String, dynamic>{};

  // Prevent instantiation
  TypeConstants._();
}

/// Helper methods for type conversion
class TypeHelpers {
  // Convert string to enum for PlaceType
  static PlaceType stringToPlaceType(String type) {
    return PlaceType.values.firstWhere(
      (e) => e.toString() == 'PlaceType.$type',
      orElse: () => PlaceType.attraction,
    );
  }

  // Convert string to enum for TransportationType
  static TransportationType stringToTransportationType(String type) {
    return TransportationType.values.firstWhere(
      (e) => e.toString() == 'TransportationType.$type',
      orElse: () => TransportationType.walking,
    );
  }

  // Convert string to enum for MessageRole
  static MessageRole stringToMessageRole(String role) {
    return MessageRole.values.firstWhere(
      (e) => e.toString() == 'MessageRole.$role',
      orElse: () => MessageRole.user,
    );
  }

  // Convert enum to string
  static String enumToString(Enum e) => e.toString().split('.').last;

  // Prevent instantiation
  TypeHelpers._();
}
