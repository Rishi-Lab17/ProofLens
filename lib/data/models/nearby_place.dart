class NearbyPlace {
  const NearbyPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.icon,
  });

  final String id;
  final String name;
  final String category;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
  final String icon;

  String get coordinates =>
      '${latitude.toStringAsFixed(6)}, '
      '${longitude.toStringAsFixed(6)}';

  NearbyPlace copyWithDistance({
    String? distance,
    String? eta,
  }) {
    return NearbyPlace(
      id: id,
      name: name,
      category: category,
      address: address,
      latitude: latitude,
      longitude: longitude,
      description: description,
      icon: icon,
    );
  }
}