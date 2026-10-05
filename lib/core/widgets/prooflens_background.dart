import 'dart:ui';

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
        // Clean premium base.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF07111F),
                      Color(0xFF0B1728),
                      Color(0xFF071A25),
                    ]
                  : const [
                      Color(0xFFF7FAFF),
                      Color(0xFFEEF6FF),
                      Color(0xFFF6FBFC),
                    ],
            ),
          ),
        ),

        // Soft blue atmospheric glow.
        Positioned(
          top: -120,
          right: -90,
          child: _GlowOrb(
            size: 300,
            color: const Color(0xFF0B6DFF),
            opacity: isDark ? 0.18 : 0.10,
          ),
        ),

        // Soft cyan atmospheric glow.
        Positioned(
          top: 260,
          left: -150,
          child: _GlowOrb(
            size: 280,
            color: const Color(0xFF10BFC4),
            opacity: isDark ? 0.12 : 0.07,
          ),
        ),

        // Very subtle bottom glow.
        Positioned(
          bottom: -160,
          right: -80,
          child: _GlowOrb(
            size: 320,
            color: const Color(0xFF2563EB),
            opacity: isDark ? 0.10 : 0.055,
          ),
        ),

        // Very light frosted atmospheric layer.
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: const SizedBox.expand(),
          ),
        ),

        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}
