import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/evidence_id_generator.dart';
import '../../../../data/models/evidence.dart';
import '../../../../data/repositories/evidence_repository.dart';

class CapturePreviewScreen extends StatefulWidget {
  const CapturePreviewScreen({
    super.key,
    this.imagePath,
    this.address,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.altitude,
    this.direction,
    this.capturedAt,
  });

  final String? imagePath;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final double? altitude;
  final double? direction;
  final DateTime? capturedAt;

  @override
  State<CapturePreviewScreen> createState() => _CapturePreviewScreenState();
}

class _CapturePreviewScreenState extends State<CapturePreviewScreen> {
  late final Evidence _evidence;

  bool _saving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();

    _evidence = Evidence(
      id: EvidenceIdGenerator.generate(),
      imagePath: widget.imagePath ?? '',
      address: widget.address ?? 'Location unavailable',
      latitude: widget.latitude ?? 0,
      longitude: widget.longitude ?? 0,
      accuracy: widget.accuracy ?? 0,
      altitude: widget.altitude ?? 0,
      direction: widget.direction ?? 0,
      capturedAt: widget.capturedAt ?? DateTime.now(),
      locationConfidence: widget.accuracy == null ? 0 : 100,
    );
  }

  bool get _hasRealLocation =>
      widget.latitude != null && widget.longitude != null;

  bool get _hasImage {
    final path = widget.imagePath;

    return path != null && path.isNotEmpty && File(path).existsSync();
  }

  Future<void> _saveEvidence() async {
    if (_saving || _saved) return;

    if (!_hasImage) {
      _showMessage('The captured image could not be found.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      // The existing repository's save method returns void.
      // Do not use await unless the repository API changes.
      EvidenceRepository.instance.save(_evidence);

      if (!mounted) return;

      setState(() {
        _saving = false;
        _saved = true;
      });

      Navigator.pushReplacementNamed(
        context,
        RouteNames.evidenceDetails,
        arguments: _evidence,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      _showMessage('Unable to save evidence: $error');
    }
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
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImagePreview(),
                    const SizedBox(height: 18),
                    _buildEvidenceCard(),
                    const SizedBox(height: 18),
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Evidence Preview',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_hasImage)
              Image.file(
                File(widget.imagePath!),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const _ImageUnavailable();
                },
              )
            else
              const _ImageUnavailable(),

            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      _hasRealLocation
                          ? Icons.location_on_rounded
                          : Icons.location_searching_rounded,
                      color: _hasRealLocation
                          ? const Color(0xFF67E8A5)
                          : const Color(0xFFFFD166),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _hasRealLocation
                            ? 'GPS coordinates received'
                            : 'GPS data not available',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      _hasRealLocation ? 'GPS OK' : 'PENDING',
                      style: TextStyle(
                        color: _hasRealLocation
                            ? const Color(0xFF67E8A5)
                            : const Color(0xFFFFD166),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111E30),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF263B55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Evidence metadata',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _metadataRow(
            Icons.location_on_rounded,
            'Location',
            _evidence.address,
          ),
          _metadataRow(
            Icons.gps_fixed_rounded,
            'Coordinates',
            _hasRealLocation ? _evidence.formattedCoordinates : 'Unavailable',
          ),
          _metadataRow(
            Icons.gps_not_fixed_rounded,
            'GPS Accuracy',
            widget.accuracy == null
                ? 'Unavailable'
                : _evidence.formattedAccuracy,
          ),
          _metadataRow(
            Icons.terrain_rounded,
            'Altitude',
            widget.altitude == null
                ? 'Unavailable'
                : _evidence.formattedAltitude,
          ),
          _metadataRow(
            Icons.explore_rounded,
            'Direction',
            widget.direction == null
                ? 'Unavailable'
                : _evidence.formattedDirection,
          ),
          _metadataRow(
            Icons.access_time_rounded,
            'Captured',
            _evidence.capturedAt.toLocal().toString().split('.').first,
          ),
          _metadataRow(Icons.fingerprint_rounded, 'Evidence ID', _evidence.id),
        ],
      ),
    );
  }

  Widget _metadataRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: const Color(0xFF65D9FF)),
          const SizedBox(width: 11),
          SizedBox(
            width: 105,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retake'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF65D9FF)),
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton.icon(
            onPressed: _saving || _saved ? null : _saveEvidence,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(
              _saving
                  ? 'Saving...'
                  : _saved
                  ? 'Saved'
                  : 'Save Evidence',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1687E8),
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageUnavailable extends StatelessWidget {
  const _ImageUnavailable();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF101827),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: Colors.white54,
                size: 48,
              ),
              SizedBox(height: 12),
              Text(
                'Captured image unavailable',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
