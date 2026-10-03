import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  bool _flashEnabled = false;
  bool _frontCamera = false;
  bool _capturing = false;

  late final AnimationController _captureController;

  @override
  void initState() {
    super.initState();

    _captureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _captureController.dispose();
    super.dispose();
  }

  Future<void> _captureEvidence() async {
    if (_capturing) return;

    setState(() {
      _capturing = true;
    });

    await _captureController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    await _captureController.reverse();

    if (!mounted) return;

    setState(() {
      _capturing = false;
    });

    Navigator.pushNamed(context, RouteNames.capturePreview);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/prooflens_background.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: Color(0xFF101827));
            },
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.58),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.82),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const Spacer(),
                _buildLocationOverlay(),
                const SizedBox(height: 20),
                _buildCaptureControls(size),
              ],
            ),
          ),

          if (_capturing)
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(color: Colors.white.withValues(alpha: 0.75)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.gps_fixed_rounded,
                  color: Color(0xFF65D9FF),
                  size: 16,
                ),
                SizedBox(width: 7),
                Text(
                  'GPS READY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _circleButton(
            icon: _flashEnabled
                ? Icons.flash_on_rounded
                : Icons.flash_off_rounded,
            onPressed: () {
              setState(() {
                _flashEnabled = !_flashEnabled;
              });
            },
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
        color: Colors.black.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Color(0xFF65D9FF),
                size: 19,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bengaluru, Karnataka',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '98%',
                style: TextStyle(
                  color: Color(0xFF67E8A5),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _MetadataItem(icon: Icons.gps_fixed_rounded, label: '±4.2 m'),
              SizedBox(width: 18),
              _MetadataItem(icon: Icons.explore_rounded, label: 'NE 42°'),
              SizedBox(width: 18),
              _MetadataItem(icon: Icons.terrain_rounded, label: '914 m'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureControls(Size size) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleButton(
            icon: Icons.photo_library_outlined,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Local gallery selection will be connected in the production camera.',
                  ),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: _captureEvidence,
            child: AnimatedScale(
              scale: _capturing ? 0.88 : 1,
              duration: const Duration(milliseconds: 120),
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
                    color: const Color(0xFF1687E8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1687E8).withValues(alpha: 0.45),
                        blurRadius: 22,
                        spreadRadius: 2,
                      ),
                    ],
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
            icon: _frontCamera
                ? Icons.camera_front_rounded
                : Icons.flip_camera_ios_rounded,
            onPressed: () {
              setState(() {
                _frontCamera = !_frontCamera;
              });
            },
          ),
        ],
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

class _MetadataItem extends StatelessWidget {
  const _MetadataItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 15),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
