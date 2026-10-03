import 'package:flutter/material.dart';

import '../../../../data/models/destination.dart';
import '../../../map/presentation/widgets/mock_map.dart';

class SimulatedNavigationScreen extends StatefulWidget {
  const SimulatedNavigationScreen({super.key, required this.destination});

  final Destination destination;

  @override
  State<SimulatedNavigationScreen> createState() =>
      _SimulatedNavigationScreenState();
}

class _SimulatedNavigationScreenState extends State<SimulatedNavigationScreen> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: MockMap(
                latitude: widget.destination.latitude,
                longitude: widget.destination.longitude,
                markerLabel: widget.destination.name,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  _button(Icons.close_rounded, () => Navigator.pop(context)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.navigation_rounded,
                          color: Color(0xFF1687E8),
                          size: 17,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'SIMULATED',
                          style: TextStyle(
                            color: Color(0xFF12213A),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildNavigationCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _started ? 'Continue towards' : 'Route to destination',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.destination.name,
            style: const TextStyle(
              color: Color(0xFF12213A),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _routeInfo(Icons.straighten_rounded, widget.destination.distance),
              const SizedBox(width: 10),
              _routeInfo(Icons.schedule_rounded, widget.destination.eta),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                setState(() {
                  _started = true;
                });
              },
              icon: Icon(
                _started ? Icons.navigation_rounded : Icons.play_arrow_rounded,
              ),
              label: Text(_started ? 'Navigation Active' : 'Start Navigation'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1687E8),
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeInfo(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1687E8), size: 16),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF12213A),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, color: const Color(0xFF12213A)),
        ),
      ),
    );
  }
}
