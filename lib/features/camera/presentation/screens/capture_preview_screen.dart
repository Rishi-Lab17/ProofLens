import 'dart:io';

import 'package:flutter/material.dart';

class CapturePreviewScreen extends StatefulWidget {
  const CapturePreviewScreen({
    super.key,
    this.imagePath,
    this.latitude,
    this.longitude,
    this.address,
    this.capturedAt,
  });

  final String? imagePath;
  final double? latitude;
  final double? longitude;
  final String? address;
  final DateTime? capturedAt;

  @override
  State<CapturePreviewScreen> createState() => _CapturePreviewScreenState();
}

class _CapturePreviewScreenState extends State<CapturePreviewScreen> {
  bool _saving = false;

  String get _coordinates {
    if (widget.latitude == null || widget.longitude == null) {
      return 'Location unavailable';
    }

    return '${widget.latitude!.toStringAsFixed(6)}, '
        '${widget.longitude!.toStringAsFixed(6)}';
  }

  String get _dateTime {
    final date = widget.capturedAt;

    if (date == null) {
      return 'Capture time unavailable';
    }

    return '${date.toLocal().toString().split('.').first} '
        '(${date.timeZoneName})';
  }

  Future<void> _saveImage() async {
    if (_saving) return;

    final path = widget.imagePath;

    if (path == null || !File(path).existsSync()) {
      _showMessage('The captured image could not be found.');
      return;
    }

    setState(() => _saving = true);

    try {
      // The camera capture is already stored at this path.
      // A separate gallery export will be implemented in the
      // photo-storage stage.
      _showMessage('Photo captured successfully.');
    } catch (error) {
      _showMessage('Unable to process the photo: $error');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.imagePath;
    final imageExists = path != null && File(path).existsSync();

    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07111F),
        foregroundColor: Colors.white,
        title: const Text('Capture Preview'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111E30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF263B55)),
                ),
                clipBehavior: Clip.antiAlias,
                child: imageExists
                    ? Image.file(
                        File(path),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const _EmptyPreview(
                            message: 'Unable to display this image.',
                          );
                        },
                      )
                    : const _EmptyPreview(
                        message: 'No captured image was provided.',
                      ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111E30),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF263B55)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CAPTURE INFORMATION',
                    style: TextStyle(
                      color: Color(0xFF65D9FF),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: widget.address ?? 'Address unavailable',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.gps_fixed, label: _coordinates),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.access_time, label: _dateTime),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Retake'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF65D9FF)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _saveImage,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(_saving ? 'Please wait' : 'Save'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1687E8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.image_not_supported_outlined,
              color: Colors.white54,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF65D9FF)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
