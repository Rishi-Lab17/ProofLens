import 'package:flutter/foundation.dart';

import '../../../../data/models/app_settings.dart';
import '../../../../data/repositories/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({SettingsRepository? repository})
    : _repository = repository ?? SettingsRepository();

  final SettingsRepository _repository;

  AppSettings _settings = const AppSettings();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  AppSettings get settings => _settings;
  OverlaySettings get imageOverlay => _settings.imageOverlay;
  OverlaySettings get videoOverlay => _settings.videoOverlay;

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  Future<void> loadSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _settings = await _repository.loadSettings();
    } catch (error) {
      _errorMessage = 'Could not load settings: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveSettings() async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.saveSettings(_settings);

      if (!success) {
        _errorMessage = 'Settings could not be saved.';
      }

      return success;
    } catch (error) {
      _errorMessage = 'Could not save settings: $error';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateImageOverlay(OverlaySettings overlay) async {
    _settings = _settings.copyWith(imageOverlay: overlay);
    notifyListeners();
    return saveSettings();
  }

  Future<bool> updateVideoOverlay(OverlaySettings overlay) async {
    _settings = _settings.copyWith(videoOverlay: overlay);
    notifyListeners();
    return saveSettings();
  }

  Future<bool> updateGeneralSettings({
    bool? saveOriginalPhotos,
    bool? saveStampedPhotos,
    bool? saveOriginalVideos,
    bool? saveStampedVideos,
    bool? useTrueNorth,
  }) async {
    _settings = _settings.copyWith(
      saveOriginalPhotos: saveOriginalPhotos,
      saveStampedPhotos: saveStampedPhotos,
      saveOriginalVideos: saveOriginalVideos,
      saveStampedVideos: saveStampedVideos,
      useTrueNorth: useTrueNorth,
    );

    notifyListeners();
    return saveSettings();
  }

  Future<bool> resetSettings() async {
    _settings = const AppSettings();
    notifyListeners();
    return saveSettings();
  }
}
