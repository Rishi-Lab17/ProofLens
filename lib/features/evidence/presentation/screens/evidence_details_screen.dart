import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/router/route_names.dart';
import '../../../../data/models/evidence.dart';
import '../../../map/presentation/widgets/mock_map.dart';

class EvidenceDetailsScreen extends StatelessWidget {
  const EvidenceDetailsScreen({super.key, required this.evidence});

  final Evidence evidence;

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    final hour = date.hour == 0
        ? 12
        : date.hour > 12
        ? date.hour - 12
        : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/${date.year} • '
        '$hour:$minute $period';
  }

  void _copy(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _share(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.shareExport, arguments: evidence);
  }

  void _report(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.report, arguments: evidence);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Evidence Details'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(height: 16),
            _buildStatus(),
            const SizedBox(height: 16),
            _buildLocationCard(),
            const SizedBox(height: 16),
            _buildMap(),
            const SizedBox(height: 16),
            _buildTechnicalCard(),
            const SizedBox(height: 16),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.asset(evidence.imagePath, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildStatus() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF67E8A5).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_rounded, color: Color(0xFF15945B)),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Evidence saved',
                  style: TextStyle(
                    color: Color(0xFF12213A),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Location metadata is attached locally.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${evidence.locationConfidence}%',
            style: const TextStyle(
              color: Color(0xFF15945B),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return _sectionCard(
      title: 'Location',
      icon: Icons.location_on_rounded,
      children: [
        _detailRow('Address', evidence.address),
        _detailRow('Coordinates', evidence.formattedCoordinates),
        _detailRow('GPS accuracy', evidence.formattedAccuracy),
      ],
    );
  }

  Widget _buildMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 3, bottom: 10),
          child: Text(
            'Location on map',
            style: TextStyle(
              color: Color(0xFF12213A),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        MockMap(
          latitude: evidence.latitude,
          longitude: evidence.longitude,
          markerLabel: 'Evidence location',
          height: 230,
        ),
      ],
    );
  }

  Widget _buildTechnicalCard() {
    return _sectionCard(
      title: 'Capture information',
      icon: Icons.info_outline_rounded,
      children: [
        _detailRow('Captured', _formatDate(evidence.capturedAt)),
        _detailRow('Direction', evidence.formattedDirection),
        _detailRow('Altitude', evidence.formattedAltitude),
        _detailRow('Evidence ID', evidence.id),
      ],
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1687E8), size: 21),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF12213A),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
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

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _share(context),
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share / Export'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1687E8),
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _copy(context, evidence.id);
                },
                icon: const Icon(Icons.fingerprint_rounded),
                label: const Text('Copy ID'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _copy(context, evidence.formattedCoordinates);
                },
                icon: const Icon(Icons.location_on_outlined),
                label: const Text('Copy GPS'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => _report(context),
            icon: const Icon(Icons.description_outlined),
            label: const Text('Preview Evidence Report'),
          ),
        ),
      ],
    );
  }
}
