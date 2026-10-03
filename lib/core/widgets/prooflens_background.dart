import 'package:flutter/material.dart';

class ProofLensBackground extends StatelessWidget {
  const ProofLensBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Main ProofLens background image.
        Image.asset(
          'assets/images/prooflens_background.jpg',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return const ColoredBox(color: Color(0xFFF4F7FC));
          },
        ),

        // Light readability layer.
        // Kept low so the original image remains clearly visible.
        ColoredBox(
          color: isDark
              ? Colors.black.withValues(alpha: 0.38)
              : Colors.white.withValues(alpha: 0.22),
        ),

        // Subtle ProofLens blue/cyan branding overlay.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0B4AA2).withValues(alpha: isDark ? 0.18 : 0.04),
                Colors.transparent,
                const Color(0xFF0EA5A8)
                    .withValues(alpha: isDark ? 0.10 : 0.025),
              ],
            ),
          ),
        ),

        // Dashboard and other screen content.
        child,
      ],
    );
  }
}
