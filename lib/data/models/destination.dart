class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.eta,
    required this.description,
  });

  final String id;
  final String name;
  final String address;
  final String category;
  final double latitude;
  final double longitude;
  final String distance;
  final String eta;
  final String description;

  String get coordinates =>
      '${latitude.toStringAsFixed(5)}, '
      '${longitude.toStringAsFixed(5)}';
}
