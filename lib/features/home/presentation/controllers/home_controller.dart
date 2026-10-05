import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../data/models/location_data.dart';
import '../../../../data/repositories/location_repository.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    LocationRepository? locationRepository,
  }) : _locationRepository =
            locationRepository ?? LocationRepository();

  final LocationRepository _locationRepository;

  LocationData? _location;

  bool _loading = false;

  bool _usingFallback = false;

  String? _errorMessage;

  StreamSubscription<LocationData>? _locationSubscription;

  /// Current live location.
  LocationData? get location => _location;

  /// Whether the initial GPS request is running.
  bool get loading => _loading;

  /// Backward-compatible loading getter.
  bool get isLoading => _loading;

  /// Whether the controller is currently showing fallback data.
  bool get usingFallback => _usingFallback;

  /// Backward-compatible fallback getter.
  bool get isUsingFallback => _usingFallback;

  /// Whether a location is currently available.
  bool get hasLocation => _location != null;

  /// Current location error, if any.
  String? get errorMessage => _errorMessage;

  /// Gets the device's current location and then starts
  /// continuous location tracking.
  Future<void> loadLocation() async {
    if (_loading) {
      return;
    }

    _loading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final currentLocation =
          await _locationRepository.getCurrentLocation();

      _location = currentLocation;

      _usingFallback = false;

      _errorMessage = null;

      // Start continuous GPS tracking after the
      // first successful location is received.
      _startLocationTracking();
    } catch (error) {
      _location = null;

      _usingFallback = false;

      _errorMessage = error.toString();
    } finally {
      _loading = false;

      notifyListeners();
    }
  }

  /// Starts listening to live GPS updates.
  void _startLocationTracking() {
    // Prevent multiple GPS subscriptions.
    _locationSubscription?.cancel();

    _locationSubscription =
        _locationRepository.watchLocation().listen(
      (updatedLocation) {
        // Replace the previous location with the
        // newest GPS position.
        _location = updatedLocation;

        _usingFallback = false;

        _errorMessage = null;

        // Rebuild the Home screen with the new
        // coordinates, accuracy, altitude and heading.
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();

        notifyListeners();
      },
    );
  }

  /// Manually refreshes the current location.
  Future<void> refreshLocation() async {
    await loadLocation();
  }

  /// Backward-compatible refresh method.
  Future<void> refresh() async {
    await loadLocation();
  }

  /// Clears the current location.
  void clearLocation() {
    _location = null;

    _errorMessage = null;

    _usingFallback = false;

    notifyListeners();
  }

  /// Stops GPS tracking and disposes the controller.
  @override
  void dispose() {
    _locationSubscription?.cancel();

    _locationSubscription = null;

    super.dispose();
  }
}