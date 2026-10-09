import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/main_navigation.dart';
import '../controllers/home_controller.dart';
import '../widgets/location_status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();

    _controller = HomeController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadLocation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openRoute(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  void _openNearbyPlaces() {
    final location = _controller.location;

    if (location == null) {
      _controller.loadLocation();
      return;
    }

    Navigator.of(context).pushNamed(
      RouteNames.nearbyPlaces,
      arguments: location,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: Row(
              children: [
                const _GlassLogo(),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ProofLens',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Discover â€¢ Capture â€¢ Verify',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.68,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _GlassIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: 'Settings',
                  onTap: () {
                    _openRoute(context, RouteNames.settings);
                  },
                ),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    120,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 1100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchBar(context, isDark),

                          const SizedBox(height: 14),

                          LocationStatusCard(
                            location: _controller.location,
                            loading: _controller.loading,
                            usingFallback: _controller.usingFallback,
                            errorMessage: _controller.errorMessage,
                            onRefresh: _controller.refreshLocation,
                          ),

                          const SizedBox(height: 18),

                          _buildHeroCard(context, isDark),

                          const SizedBox(height: 22),

                          _buildNearbyGlassCard(context, isDark),

                          const SizedBox(height: 24),

                          Text(
                            'Explore ProofLens',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),

                          const SizedBox(height: 12),

                           Column(
                             children: [
                               _ActionCard(
                                 icon: Icons.camera_alt_rounded,
                                 title: 'GPS Camera',
                                 subtitle: 'Capture location-aware evidence',
                                 onTap: () => _openRoute(
                                   context,
                                   RouteNames.camera,
                                 ),
                               ),
                               const SizedBox(height: 12),
                               _ActionCard(
                                 icon: Icons.my_location_rounded,
                                 title: 'Where Am I?',
                                 subtitle: 'View your current location',
                                 onTap: () => _openRoute(
                                   context,
                                   RouteNames.location,
                                 ),
                               ),
                               const SizedBox(height: 12),
                               _ActionCard(
                                 icon: Icons.search_rounded,
                                 title: 'Destination',
                                 subtitle: 'Find a place to explore',
                                 onTap: () => _openRoute(
                                   context,
                                   RouteNames.search,
                                 ),
                               ),
                               const SizedBox(height: 12),
                               _ActionCard(
                                 icon: Icons.history_rounded,
                                 title: 'History',
                                 subtitle: 'View your evidence',
                                 onTap: () => _openRoute(
                                   context,
                                   RouteNames.history,
                                 ),
                               ),
                             ],
                           ),


                          const SizedBox(height: 26),

                          _buildRecentEvidence(context),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: _GlassCaptureButton(
            onTap: () => _openRoute(
              context,
              RouteNames.camera,
            ),
          ),
          bottomNavigationBar:
              const ProofLensMainNavigation(currentIndex: 0),
        );
      },
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    bool isDark,
  ) {
    return _GlassContainer(
      borderRadius: 22,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          _openRoute(
            context,
            RouteNames.search,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 15,
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.78)
                    : AppColors.textSecondary,
                size: 25,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search a place, landmark or destination...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.68)
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              const Icon(
                Icons.mic_none_rounded,
                color: AppColors.primary,
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    return _GlassContainer(
      borderRadius: 30,
      padding: const EdgeInsets.all(22),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -40,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(
                    alpha: 0.12,
                  ),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Positioned(
            right: 25,
            top: 15,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(
                  alpha: 0.08,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.20 : 0.09,
                  ),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: AppColors.primary.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'LOCATION INTELLIGENCE',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.primaryDark,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Capture the moment.\nVerify the place.',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                  letterSpacing: -1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Create location-aware evidence with '
                'coordinates, time and context.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.70)
                      : AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              _GlassPrimaryButton(
                icon: Icons.camera_alt_rounded,
                label: 'Open GPS Camera',
                onTap: () {
                  _openRoute(
                    context,
                    RouteNames.camera,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyGlassCard(
    BuildContext context,
    bool isDark,
  ) {
    final hasLocation = _controller.hasLocation;

    return _GlassContainer(
      borderRadius: 26,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: _openNearbyPlaces,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(
                      alpha: 0.10,
                    ),
                    border: Border.all(
                      color: AppColors.primary.withValues(
                        alpha: 0.16,
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.explore_rounded,
                    color: AppColors.primary,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Famous Places Near Me',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasLocation
                            ? 'Tourist places, temples, hospitals, '
                                'colleges and more'
                            : 'Waiting for your live location...',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.white.withValues(alpha: 0.60),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Icon(
                    hasLocation
                        ? Icons.arrow_forward_rounded
                        : Icons.gps_fixed_rounded,
                    size: 19,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentEvidence(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent evidence',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            TextButton(
              onPressed: () {
                _openRoute(
                  context,
                  RouteNames.history,
                );
              },
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _GlassContainer(
          borderRadius: 24,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColors.primary.withValues(
                      alpha: 0.09,
                    ),
                    border: Border.all(
                      color: AppColors.primary.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.photo_camera_back_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No saved evidence yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Your captured evidence will appear here.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.iconTheme.color
                      ?.withValues(alpha: 0.45),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassLogo extends StatelessWidget {
  const _GlassLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.location_searching_rounded,
        color: AppColors.primary,
        size: 22,
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
            child: Icon(
              icon,
              size: 21,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  const _GlassContainer({
    required this.child,
    this.padding,
    this.borderRadius = 24,
  });

  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.075)
                : Colors.white.withValues(alpha: 0.52),
            borderRadius:
                BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.72),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.18 : 0.055,
                ),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassPrimaryButton extends StatelessWidget {
  const _GlassPrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 19,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassCaptureButton extends StatelessWidget {
  const _GlassCaptureButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 19,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.30),
                blurRadius: 22,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Capture',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 16,
          sigmaY: 16,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius:
                BorderRadius.circular(AppRadius.card),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 108,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.065)
                    : Colors.white.withValues(alpha: 0.48),
                borderRadius:
                    BorderRadius.circular(AppRadius.card),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.70),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                        alpha: isDark ? 0.15 : 0.08,
                      ),
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: isDark
                                    ? Colors.white
                                        .withValues(
                                        alpha: 0.60,
                                      )
                                    : AppColors
                                        .textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.42)
                        : AppColors.textSecondary
                            .withValues(alpha: 0.65),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
