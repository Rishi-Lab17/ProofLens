import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _contentController;

  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentSlide;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _contentOpacity = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.easeOutCubic,
      ),
    );

    _contentController.forward();

    _timer = Timer(
      const Duration(milliseconds: 2800),
      _openHome,
    );
  }

  void _openHome() {
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      RouteNames.home,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Existing ProofLens background.
          Image.asset(
            'assets/images/prooflens_background.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),

          // Covers the branding already embedded in the JPG.
          // This does NOT replace or generate the background image.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.sizeOf(context).height * 0.31,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF06182C).withValues(alpha: 0.98),
                      const Color(0xFF0A2945).withValues(alpha: 0.96),
                      const Color(0xFF123653).withValues(alpha: 0.94),
                      const Color(0xFF123653).withValues(alpha: 0.15),
                    ],
                    stops: const [
                      0.0,
                      0.45,
                      0.78,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Soft overall readability overlay.
          Positioned.fill(
            child: IgnorePointer(
              child: ColoredBox(
                color: Colors.black26,
              ),
            ),
          ),

          // Splash content.
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: FadeTransition(
                  opacity: _contentOpacity,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),

                        // Clean text branding.
                        Text(
                          'ProofLens',
                          textAlign: TextAlign.center,
                          style: AppTypography.display.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(
                                  alpha: 0.45,
                                ),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Capture • Locate • Verify',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyLarge.copyWith(
                            color: Colors.white.withValues(
                              alpha: 0.86,
                            ),
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(
                          height: AppSpacing.xl,
                        ),

                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxWidth: 370,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF071B33,
                            ).withValues(alpha: 0.82),
                            borderRadius:
                                BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: 0.16,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.30,
                                ),
                                blurRadius: 30,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.30),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your trusted companion',
                                      style: AppTypography
                                          .titleMedium
                                          .copyWith(
                                        color: Colors.white,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'for real-world evidence',
                                      style: AppTypography
                                          .bodyMedium
                                          .copyWith(
                                        color: Colors.white
                                            .withValues(
                                          alpha: 0.68,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        const SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.8,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'Preparing your workspace...',
                          style: AppTypography.labelMedium.copyWith(
                            color: Colors.white.withValues(
                              alpha: 0.72,
                            ),
                            letterSpacing: 0.4,
                          ),
                        ),

                        const SizedBox(height: 32),

                        Text(
                          'CAPTURE YOUR ADVENTURE',
                          textAlign: TextAlign.center,
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white.withValues(
                              alpha: 0.58,
                            ),
                            letterSpacing: 3.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          width: 48,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8B56A),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}