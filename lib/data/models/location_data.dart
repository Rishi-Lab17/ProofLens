class LocationData {
  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.accuracy,
    required this.altitude,
    required this.heading,
    required this.city,
    required this.country,
  });

  final double latitude;
  final double longitude;
  final String address;
  final double accuracy;
  final double altitude;
  final double heading;
  final String city;
  final String country;

  String get coordinates =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

  String get accuracyText => '±${accuracy.toStringAsFixed(1)} m';

  String get altitudeText => '${altitude.toStringAsFixed(0)} m';

  String get headingText => '${heading.toStringAsFixed(0)}°';

  LocationData copyWith({
    double? latitude,
    double? longitude,
    String? address,
    double? accuracy,
    double? altitude,
    double? heading,
    String? city,
    String? country,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      heading: heading ?? this.heading,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }
}