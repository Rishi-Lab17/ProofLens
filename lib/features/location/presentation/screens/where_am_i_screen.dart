import 'package:flutter/material.dart';

import '../../../../data/mock/mock_location_data.dart';
import '../../../../data/mock/mock_destination_data.dart';
import '../../../../data/models/destination.dart';
import '../../../map/presentation/widgets/mock_map.dart';

class WhereAmIScreen extends StatefulWidget {
  const WhereAmIScreen({super.key});

  @override
  State<WhereAmIScreen> createState() => _WhereAmIScreenState();
}

class _WhereAmIScreenState extends State<WhereAmIScreen> {
  bool _loading = true;
  bool _poorAccuracy = false;

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    });
  }

  void _toggleAccuracy() {
    setState(() {
      _poorAccuracy = !_poorAccuracy;
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = MockLocationData.current;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Where Am I?'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _toggleAccuracy,
            tooltip: 'GPS status',
            icon: Icon(
              _poorAccuracy ? Icons.gps_off_rounded : Icons.gps_fixed_rounded,
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationHeader(location),
                  const SizedBox(height: 16),
                  MockMap(
                    latitude: location.latitude,
                    longitude: location.longitude,
                    markerLabel: 'You are here',
                    height: 270,
                  ),
                  const SizedBox(height: 16),
                  _buildStats(location),
                  const SizedBox(height: 16),
                  _buildNearbyPlaces(),
                  const SizedBox(height: 18),
                  _buildActions(context),
                ],
              ),
            ),
    );
  }

  Widget _buildLocationHeader(dynamic location) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF1687E8).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _poorAccuracy
                      ? Icons.gps_off_rounded
                      : Icons.my_location_rounded,
                  color: _poorAccuracy
                      ? Colors.orange
                      : const Color(0xFF1687E8),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Current location',
                  style: TextStyle(
                    color: Color(0xFF12213A),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                _poorAccuracy ? 'LOW' : '98%',
                style: TextStyle(
                  color: _poorAccuracy
                      ? Colors.orange
                      : const Color(0xFF15945B),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            location.address,
            style: const TextStyle(
              color: Color(0xFF12213A),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            location.coordinates,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          if (_poorAccuracy) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 19,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'GPS accuracy is currently low. Move to an open area for a stronger signal.',
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStats(dynamic location) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            Icons.gps_fixed_rounded,
            'Accuracy',
            _poorAccuracy ? '±32 m' : location.accuracyText,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            Icons.terrain_rounded,
            'Altitude',
            location.altitudeText,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            Icons.explore_rounded,
            'Heading',
            location.headingText,
          ),
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1687E8), size: 21),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF12213A),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyPlaces() {
    final places = MockDestinationData.destinations.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nearby places',
          style: TextStyle(
            color: Color(0xFF12213A),
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 11),
        ...places.map((place) => _nearbyCard(place)),
      ],
    );
  }

  Widget _nearbyCard(Destination place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1687E8).withValues(alpha: 0.12),
          child: const Icon(Icons.place_rounded, color: Color(0xFF1687E8)),
        ),
        title: Text(
          place.name,
          style: const TextStyle(
            color: Color(0xFF12213A),
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(place.category),
        trailing: Text(
          place.distance,
          style: const TextStyle(
            color: Color(0xFF1687E8),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Location saved to your local ProofLens history.',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.bookmark_outline_rounded),
            label: const Text('Save'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Location sharing is ready for the native share layer.',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share'),
          ),
        ),
      ],
    );
  }
}
