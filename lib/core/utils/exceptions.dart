class CacheException implements Exception {
  final String message;

  CacheException([this.message = "Cache Error"]);

  @override
  String toString() => "CacheException: $message";
}

class ConfigException implements Exception {
  final String message;

  ConfigException(this.message);

  @override
  String toString() => 'ConfigException: $message';
}

class FactoryException implements Exception {
  final String message;

  FactoryException(this.message);

  @override
  String toString() => 'FactoryException: $message';
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? " (Status code: $statusCode)" : ""}';
  }
}

class NFCUnavailableException implements Exception {
  final String message;

  NFCUnavailableException([this.message = "NFC is not available on this device."]);

  @override
  String toString() => "NFCUnavailableException: $message";
}

class NFCReadException implements Exception {
  final String message;

  NFCReadException([this.message = "Failed to read NFC tag."]);

  @override
  String toString() => "NFCReadException: $message";
}

class NFCWriteException implements Exception {
  final String message;

  NFCWriteException([this.message = "Failed to write NFC tag."]);

  @override
  String toString() => "NFCWriteException: $message";
}

class NFCTagCapacityException implements Exception {
  final String message;

  NFCTagCapacityException([this.message = "Data exceeds tag capacity."]);

  @override
  String toString() => "NFCTagCapacityException: $message";
}

class NFCSaveException implements Exception {
  final String message;

  NFCSaveException([this.message = "Error saving tag and card."]);

  @override
  String toString() => "NFCSaveException: $message";
}

class NFCTimeoutException implements Exception {
  final String message;

  NFCTimeoutException([this.message = "Operation timed out."]);

  @override
  String toString() => "NFCTimeoutException: $message";
}

class NFCGenericException implements Exception {
  final String message;

  NFCGenericException([this.message = "An unexpected error occurred during the NFC process."]);

  @override
  String toString() => "NFCGenericException: $message";
}
