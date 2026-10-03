import 'dart:math' as math;

import 'package:flutter/material.dart';

class MockMap extends StatelessWidget {
  const MockMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.markerLabel,
    this.height = 260,
  });

  final double latitude;
  final double longitude;
  final String markerLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _MapPainter()),
          Positioned(
            left: 18,
            top: 18,
            child: _mapBadge(Icons.layers_outlined, 'Map'),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    markerLabel,
                    style: const TextStyle(
                      color: Color(0xFF12213A),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1687E8),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1687E8).withValues(alpha: 0.40),
                        blurRadius: 18,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.navigation_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 15,
            bottom: 15,
            child: Column(
              children: [
                _mapControl(Icons.add_rounded),
                const SizedBox(height: 6),
                _mapControl(Icons.remove_rounded),
              ],
            ),
          ),
          Positioned(
            left: 15,
            bottom: 15,
            child: _mapBadge(
              Icons.my_location_rounded,
              '${latitude.toStringAsFixed(4)}, '
              '${longitude.toStringAsFixed(4)}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF1687E8)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF12213A),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapControl(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: const Color(0xFF12213A)),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFE8F0E7);

    canvas.drawRect(Offset.zero & size, background);

    final minorRoad = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final majorRoad = Paint()
      ..color = const Color(0xFFFFD98A)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;

    final river = Paint()
      ..color = const Color(0xFF9ED8F1)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(-20, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.35,
        size.width + 30,
        size.height * 0.52,
      );

    final path2 = Path()
      ..moveTo(size.width * 0.12, -20)
      ..quadraticBezierTo(
        size.width * 0.40,
        size.height * 0.50,
        size.width * 0.76,
        size.height + 20,
      );

    final path3 = Path()
      ..moveTo(-20, size.height * 0.20)
      ..quadraticBezierTo(
        size.width * 0.52,
        size.height * 0.75,
        size.width + 20,
        size.height * 0.18,
      );

    canvas.drawPath(path1, majorRoad);
    canvas.drawPath(path2, minorRoad);
    canvas.drawPath(path3, minorRoad);

    final waterPath = Path()
      ..moveTo(size.width * 0.75, -10)
      ..cubicTo(
        size.width * 0.60,
        size.height * 0.28,
        size.width * 0.88,
        size.height * 0.58,
        size.width * 0.67,
        size.height + 20,
      );

    canvas.drawPath(waterPath, river);

    final park = Paint()
      ..color = const Color(0xFFC8E7B7)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.22, size.height * 0.28),
        width: size.width * 0.28,
        height: size.height * 0.20,
      ),
      park,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.77, size.height * 0.76),
        width: size.width * 0.25,
        height: size.height * 0.17,
      ),
      park,
    );

    final smallRoad = Paint()
      ..color = Colors.white.withValues(alpha: 0.78)
      ..strokeWidth = 4;

    for (var i = 0; i < 6; i++) {
      final y = size.height * (0.10 + i * 0.16);

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + math.sin(i) * 35),
        smallRoad,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
