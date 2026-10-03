class Evidence {
  const Evidence({
    required this.id,
    required this.imagePath,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.direction,
    required this.capturedAt,
    required this.locationConfidence,
  });

  final String id;
  final String imagePath;
  final String address;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double altitude;
  final double direction;
  final DateTime capturedAt;
  final int locationConfidence;

  String get formattedCoordinates =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

  String get formattedAccuracy => '${accuracy.toStringAsFixed(1)} m';

  String get formattedAltitude => '${altitude.toStringAsFixed(1)} m';

  String get formattedDirection => '${direction.toStringAsFixed(0)}°';

  Evidence copyWith({
    String? id,
    String? imagePath,
    String? address,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? altitude,
    double? direction,
    DateTime? capturedAt,
    int? locationConfidence,
  }) {
    return Evidence(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      direction: direction ?? this.direction,
      capturedAt: capturedAt ?? this.capturedAt,
      locationConfidence: locationConfidence ?? this.locationConfidence,
    );
  }
}
