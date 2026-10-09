import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class GpsLensCameraController extends ChangeNotifier {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  bool _initializing = false;
  bool _takingPhoto = false;
  bool _disposed = false;
  String? _errorMessage;

  FlashMode _flashMode = FlashMode.off;
  int _cameraIndex = 0;

  CameraController? get controller => _controller;

  bool get isInitialized =>
      _controller != null && _controller!.value.isInitialized;

  bool get isInitializing => _initializing;

  bool get isTakingPhoto => _takingPhoto;

  String? get errorMessage => _errorMessage;

  FlashMode get flashMode => _flashMode;

  bool get flashEnabled => _flashMode != FlashMode.off;

  bool get hasCameras => _cameras.isNotEmpty;

  Future<void> initialize() async {
    if (_initializing || _disposed) return;

    _initializing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        throw CameraException(
          'NoCameraAvailable',
          'No camera was detected on this device.',
        );
      }

      _cameraIndex = _preferredCameraIndex();
      await _openCamera(_cameras[_cameraIndex]);
    } on CameraException catch (error) {
      _errorMessage = _friendlyCameraError(error);
    } catch (error) {
      _errorMessage = 'Unable to initialize the camera: $error';
    } finally {
      _initializing = false;

      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  int _preferredCameraIndex() {
    final rearIndex = _cameras.indexWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    return rearIndex >= 0 ? rearIndex : 0;
  }

  Future<void> _openCamera(CameraDescription description) async {
    final previousController = _controller;
    _controller = null;

    if (previousController != null) {
      await previousController.dispose();
    }

    _flashMode = FlashMode.off;

    final newController = CameraController(
      description,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _controller = newController;

    try {
      await newController.initialize();

      if (_disposed || _controller != newController) {
        await newController.dispose();
        return;
      }

      await newController.setFlashMode(FlashMode.off);
    } catch (_) {
      if (_controller == newController) {
        _controller = null;
      }

      await newController.dispose();
      rethrow;
    }
  }

  Future<void> switchCamera() async {
    if (_disposed || _initializing || _takingPhoto || _cameras.length < 2) {
      return;
    }

    _initializing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cameraIndex = (_cameraIndex + 1) % _cameras.length;
      await _openCamera(_cameras[_cameraIndex]);
    } on CameraException catch (error) {
      _errorMessage = _friendlyCameraError(error);
    } catch (error) {
      _errorMessage = 'Unable to switch camera: $error';
    } finally {
      _initializing = false;

      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  Future<void> toggleFlash() async {
    final current = _controller;

    if (_disposed ||
        current == null ||
        !current.value.isInitialized ||
        _initializing ||
        _takingPhoto) {
      return;
    }

    final nextMode = _flashMode == FlashMode.off
        ? FlashMode.torch
        : FlashMode.off;

    try {
      await current.setFlashMode(nextMode);
      _flashMode = nextMode;
      _errorMessage = null;
    } on CameraException catch (error) {
      _errorMessage = _friendlyCameraError(error);
    } catch (error) {
      _errorMessage = 'Unable to change flash mode: $error';
    }

    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<XFile?> takePhoto() async {
    final current = _controller;

    if (_disposed ||
        current == null ||
        !current.value.isInitialized ||
        _initializing ||
        _takingPhoto) {
      return null;
    }

    _takingPhoto = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final photo = await current.takePicture();

      if (_disposed) return null;

      return photo;
    } on CameraException catch (error) {
      _errorMessage = _friendlyCameraError(error);
      return null;
    } catch (error) {
      _errorMessage = 'Unable to capture photo: $error';
      return null;
    } finally {
      _takingPhoto = false;

      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  String _friendlyCameraError(CameraException error) {
    switch (error.code) {
      case 'CameraAccessDenied':
        return 'Camera permission was denied. Allow camera access in settings.';
      case 'CameraAccessDeniedWithoutPrompt':
        return 'Camera permission is disabled. Enable it in device settings.';
      case 'CameraAccessRestricted':
        return 'Camera access is restricted on this device.';
      case 'NoCameraAvailable':
        return 'No camera is available.';
      default:
        return error.description ?? 'Camera error: ${error.code}';
    }
  }

  @override
  void dispose() {
    _disposed = true;

    final current = _controller;
    _controller = null;

    if (current != null) {
      current.dispose();
    }

    super.dispose();
  }
}
