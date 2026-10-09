import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../controllers/camera_controller.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  late final GpsLensCameraController _camera;
  late final AnimationController _captureAnimation;

  bool _openingPreview = false;

  @override
  void initState() {
    super.initState();

    _camera = GpsLensCameraController();
    _camera.addListener(_onCameraChanged);

    _captureAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      lowerBound: 0,
      upperBound: 0.15,
    );

    unawaited(_camera.initialize());
  }

  void _onCameraChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _camera.removeListener(_onCameraChanged);
    _camera.dispose();
    _captureAnimation.dispose();
    super.dispose();
  }

  Future<void> _captureEvidence() async {
    if (_openingPreview || !_camera.isInitialized) return;

    _openingPreview = true;
    await _captureAnimation.forward();
    await _captureAnimation.reverse();

    final XFile? photo = await _camera.takePhoto();

    if (!mounted) return;

    _openingPreview = false;

    if (photo == null) {
      _showMessage(_camera.errorMessage ?? 'Unable to capture photo.');
      return;
    }

    await Navigator.pushNamed(
      context,
      RouteNames.capturePreview,
      arguments: {'imagePath': photo.path, 'capturedAt': DateTime.now()},
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildCameraPreview(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0, 0.45, 1],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                _buildLocationOverlay(),
                const SizedBox(height: 24),
                _buildCaptureControls(),
              ],
            ),
          ),
          if (_camera.errorMessage != null &&
              !_camera.isInitializing &&
              !_camera.isInitialized)
            _buildCameraError(),
          if (_camera.isTakingPhoto)
            const Positioned.fill(
              child: IgnorePointer(child: ColoredBox(color: Color(0x66000000))),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    final controller = _camera.controller;

    if (controller != null &&
        controller.value.isInitialized &&
        controller.value.previewSize != null) {
      final previewSize = controller.value.previewSize!;

      return SizedBox.expand(
        child: ClipRect(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: previewSize.height,
              height: previewSize.width,
              child: CameraPreview(controller),
            ),
          ),
        ),
      );
    }

    return const ColoredBox(
      color: Color(0xFF101827),
      child: Center(child: CircularProgressIndicator(color: Color(0xFF65D9FF))),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _circleButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _camera.isInitialized
                      ? Icons.camera_alt_rounded
                      : Icons.camera_alt_outlined,
                  color: const Color(0xFF65D9FF),
                  size: 16,
                ),
                const SizedBox(width: 7),
                Text(
                  _camera.isInitialized ? 'CAMERA READY' : 'STARTING CAMERA',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _circleButton(
            icon: _camera.flashEnabled
                ? Icons.flash_on_rounded
                : Icons.flash_off_rounded,
            onPressed: _camera.toggleFlash,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationOverlay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_searching_rounded,
                color: Color(0xFF65D9FF),
                size: 19,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'GPS will be connected next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'GPS PENDING',
                style: TextStyle(
                  color: Color(0xFFFFD166),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Coordinates, accuracy, altitude and compass '
            'will appear here when real device data is connected.',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleButton(
            icon: Icons.photo_library_outlined,
            onPressed: () {
              _showMessage(
                'Gallery access will be implemented in the storage stage.',
              );
            },
          ),
          GestureDetector(
            onTap:
                _camera.isInitialized &&
                    !_camera.isTakingPhoto &&
                    !_openingPreview
                ? _captureEvidence
                : null,
            child: AnimatedBuilder(
              animation: _captureAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 - _captureAnimation.value,
                  child: child,
                );
              },
              child: Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                ),
                padding: const EdgeInsets.all(7),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _camera.isInitialized
                        ? const Color(0xFF1687E8)
                        : Colors.grey,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          _circleButton(
            icon: Icons.flip_camera_ios_rounded,
            onPressed: _camera.switchCamera,
          ),
        ],
      ),
    );
  }

  Widget _buildCameraError() {
    return Positioned.fill(
      child: Container(
        color: const Color(0xF007111F),
        padding: const EdgeInsets.all(28),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.no_photography_outlined,
                color: Color(0xFF65D9FF),
                size: 56,
              ),
              const SizedBox(height: 18),
              const Text(
                'Camera unavailable',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _camera.errorMessage ?? 'Unable to open camera.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: () => unawaited(_camera.initialize()),
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.black.withValues(alpha: 0.48),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
