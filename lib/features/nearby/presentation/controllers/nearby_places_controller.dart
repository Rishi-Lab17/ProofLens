import 'package:flutter/foundation.dart';

import '../../../../data/models/nearby_place.dart';
import '../../../../data/repositories/nearby_places_repository.dart';

class NearbyPlacesController extends ChangeNotifier {
  NearbyPlacesController({
    NearbyPlacesRepository? repository,
  }) : _repository =
            repository ?? const NearbyPlacesRepository();

  final NearbyPlacesRepository _repository;

  List<NearbyPlace> _places = [];

  bool _loading = false;

  String? _errorMessage;

  String _selectedCategory = 'All';

  double? _currentLatitude;
  double? _currentLongitude;

  List<NearbyPlace> get places => List.unmodifiable(_places);

  bool get loading => _loading;

  String? get errorMessage => _errorMessage;

  String get selectedCategory => _selectedCategory;

  bool get hasPlaces => _places.isNotEmpty;

  Future<void> loadPlaces({
    required double latitude,
    required double longitude,
  }) async {
    _currentLatitude = latitude;
    _currentLongitude = longitude;

    _loading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _places = await _repository.getNearbyPlaces(
        latitude: latitude,
        longitude: longitude,
        category: _selectedCategory,
      );
    } catch (_) {
      _errorMessage =
          'Unable to load nearby places right now.';
      _places = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> selectCategory(
    String category,
  ) async {
    _selectedCategory = category;

    notifyListeners();

    if (_currentLatitude == null ||
        _currentLongitude == null) {
      return;
    }

    await loadPlaces(
      latitude: _currentLatitude!,
      longitude: _currentLongitude!,
    );
  }

  double distanceTo(NearbyPlace place) {
    if (_currentLatitude == null ||
        _currentLongitude == null) {
      return 0;
    }

    return _repository.calculateDistance(
      fromLatitude: _currentLatitude!,
      fromLongitude: _currentLongitude!,
      toLatitude: place.latitude,
      toLongitude: place.longitude,
    );
  }

  String distanceText(NearbyPlace place) {
    return _repository.formatDistance(
      distanceTo(place),
    );
  }

  String etaText(NearbyPlace place) {
    final minutes = _repository.estimateMinutes(
      distanceTo(place),
    );

    return '$minutes min';
  }

  void clear() {
    _places = [];
    _errorMessage = null;
    notifyListeners();
  }
}