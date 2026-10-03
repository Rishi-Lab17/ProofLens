import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/evidence_id_generator.dart';
import '../../../../data/models/evidence.dart';
import '../../../../data/repositories/evidence_repository.dart';

class CapturePreviewScreen extends StatefulWidget {
  const CapturePreviewScreen({super.key});

  @override
  State<CapturePreviewScreen> createState() => _CapturePreviewScreenState();
}

class _CapturePreviewScreenState extends State<CapturePreviewScreen> {
  late final Evidence _evidence;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _evidence = Evidence(
      id: EvidenceIdGenerator.generate(),
      imagePath: 'assets/images/prooflens_background.jpg',
      address: 'Bengaluru, Karnataka, India',
      latitude: 12.998800,
      longitude: 77.592100,
      accuracy: 4.2,
      altitude: 914.0,
      direction: 42.0,
      capturedAt: DateTime.now(),
      locationConfidence: 98,
    );
  }

  Future<void> _saveEvidence() async {
    if (_saving) return;

    setState(() {
      _saving = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 700));

    EvidenceRepository.instance.save(_evidence);

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    Navigator.pushReplacementNamed(
      context,
      RouteNames.evidenceDetails,
      arguments: _evidence,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
            Image.asset(_evidence.imagePath, fit: BoxFit.cover),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.66),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF67E8A5),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Location metadata attached',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${_evidence.locationConfidence}%',
                      style: const TextStyle(
                        color: Color(0xFF67E8A5),
                        fontWeight: FontWeight.w800,
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
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Evidence metadata',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF12213A),
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
            _evidence.formattedCoordinates,
          ),
          _metadataRow(
            Icons.gps_not_fixed_rounded,
            'GPS Accuracy',
            _evidence.formattedAccuracy,
          ),
          _metadataRow(
            Icons.terrain_rounded,
            'Altitude',
            _evidence.formattedAltitude,
          ),
          _metadataRow(
            Icons.explore_rounded,
            'Direction',
            _evidence.formattedDirection,
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
          Icon(icon, size: 19, color: const Color(0xFF1687E8)),
          const SizedBox(width: 11),
          SizedBox(
            width: 105,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF12213A),
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
              side: BorderSide(color: Colors.white.withValues(alpha: 0.65)),
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
            onPressed: _saving ? null : _saveEvidence,
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
            label: Text(_saving ? 'Saving...' : 'Save Evidence'),
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
