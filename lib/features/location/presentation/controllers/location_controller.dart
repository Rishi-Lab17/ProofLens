import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../data/models/location_data.dart';
import '../../../../data/repositories/location_repository.dart';

class LocationController extends ChangeNotifier {
  LocationController({
    LocationRepository? repository,
  }) : _repository = repository ?? LocationRepository();

  final LocationRepository _repository;

  LocationData? _location;

  bool _loading = false;
  bool _usingFallback = false;
  String? _errorMessage;

  StreamSubscription<LocationData>? _locationSubscription;

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  LocationData? get location => _location;

  bool get loading => _loading;

  bool get isLoading => _loading;

  bool get usingFallback => _usingFallback;

  bool get isUsingFallback => _usingFallback;

  String? get errorMessage => _errorMessage;

  bool get hasLocation => _location != null;

  // ---------------------------------------------------------------------------
  // LOAD CURRENT LOCATION
  // ---------------------------------------------------------------------------

  Future<void> loadLocation() async {
    _loading = true;
    _errorMessage = null;
    _usingFallback = false;

    notifyListeners();

    try {
      final location = await _repository.getCurrentLocation(
        useMockFallback: true,
      );

      _location = location;

      if (location.latitude == 12.998800 &&
          location.longitude == 77.592100) {
        _usingFallback = true;
      }
    } catch (error) {
      _errorMessage = _friendlyError(error);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // LOCATION TRACKING
  // ---------------------------------------------------------------------------

  void startLocationTracking() {
    _locationSubscription?.cancel();

    _locationSubscription = _repository.watchLocation().listen(
      (location) {
        _location = location;
        _usingFallback = false;
        _errorMessage = null;

        notifyListeners();
      },
      onError: (error) {
        _errorMessage = _friendlyError(error);
        notifyListeners();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // REFRESH
  // ---------------------------------------------------------------------------

  Future<void> refresh() async {
    await loadLocation();
  }

  Future<void> refreshLocation() async {
    await refresh();
  }

  // ---------------------------------------------------------------------------
  // ERROR HANDLING
  // ---------------------------------------------------------------------------

  String _friendlyError(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('disabled')) {
      return 'Location services are turned off.';
    }

    if (message.contains('permission')) {
      return 'Location permission is required.';
    }

    return 'Unable to get your current location.';
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}