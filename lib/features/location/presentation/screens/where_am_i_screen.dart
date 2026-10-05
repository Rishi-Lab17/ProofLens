import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../data/models/location_data.dart';
import '../controllers/location_controller.dart';

class WhereAmIScreen extends StatefulWidget {
  const WhereAmIScreen({super.key});

  @override
  State<WhereAmIScreen> createState() => _WhereAmIScreenState();
}

class _WhereAmIScreenState extends State<WhereAmIScreen> {
  late final LocationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = LocationController();
    _controller.addListener(_onControllerChanged);

    _controller.loadLocation();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Where Am I?',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh location',
            onPressed: _controller.isLoading
                ? null
                : () {
                    _controller.refreshLocation();
                  },
            icon: _controller.isLoading
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: _buildBackground(
        isDark: isDark,
        child: SafeArea(
          top: false,
          child: _buildBody(context, isDark),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isDark) {
    if (_controller.isLoading && _controller.location == null) {
      return _buildLoadingState(isDark);
    }

    if (_controller.errorMessage != null &&
        _controller.location == null) {
      return _buildErrorState(context, isDark);
    }

    final location = _controller.location;

    if (location == null) {
      return _buildErrorState(context, isDark);
    }

    return RefreshIndicator(
      onRefresh: () => _controller.refreshLocation(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
        children: [
          _buildLocationHeader(location, isDark),
          const SizedBox(height: 16),

          if (_controller.isUsingFallback) ...[
            _buildFallbackNotice(isDark),
            const SizedBox(height: 16),
          ],

          _buildLiveMap(location, isDark),
          const SizedBox(height: 16),

          _buildLocationInformation(location, isDark),
          const SizedBox(height: 16),

          _buildGpsStats(location, isDark),
          const SizedBox(height: 16),

          _buildAccuracyNotice(location, isDark),
          const SizedBox(height: 16),

          _buildNearbyPreview(context, isDark),
          const SizedBox(height: 16),

          _buildActions(context, location, isDark),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BACKGROUND
  // ---------------------------------------------------------------------------

  Widget _buildBackground({
    required bool isDark,
    required Widget child,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF07111F),
                      Color(0xFF0A1627),
                      Color(0xFF07111F),
                    ]
                  : const [
                      Color(0xFFF7FAFF),
                      Color(0xFFEFF6FF),
                      Color(0xFFF8FBFF),
                    ],
            ),
          ),
        ),

        Positioned(
          top: -90,
          right: -80,
          child: _GlowOrb(
            size: 250,
            color: const Color(0xFF0B6DFF).withValues(
              alpha: isDark ? 0.18 : 0.12,
            ),
          ),
        ),

        Positioned(
          top: 300,
          left: -120,
          child: _GlowOrb(
            size: 270,
            color: const Color(0xFF00B8D9).withValues(
              alpha: isDark ? 0.12 : 0.09,
            ),
          ),
        ),

        Positioned.fill(child: child),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // LOADING
  // ---------------------------------------------------------------------------

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _GlassContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 32,
          ),
          borderRadius: 30,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B6DFF).withValues(
                    alpha: isDark ? 0.18 : 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Finding your location',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF10213A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ProofLens is getting your current GPS coordinates and accuracy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: isDark
                      ? Colors.white60
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ERROR
  // ---------------------------------------------------------------------------

  Widget _buildErrorState(
    BuildContext context,
    bool isDark,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _GlassContainer(
          padding: const EdgeInsets.all(28),
          borderRadius: 30,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(
                    alpha: isDark ? 0.16 : 0.08,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_off_rounded,
                  size: 34,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Location unavailable',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF10213A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _controller.errorMessage ??
                    'ProofLens could not get your current location.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: isDark
                      ? Colors.white60
                      : Colors.black54,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    _controller.refreshLocation();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LOCATION HEADER
  // ---------------------------------------------------------------------------

  Widget _buildLocationHeader(
    LocationData location,
    bool isDark,
  ) {
    return _GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0B6DFF),
                      Color(0xFF00A9D6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0B6DFF)
                          .withValues(alpha: 0.20),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Live Location',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white60
                                  : Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16C784),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF10213A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0B6DFF).withValues(
                alpha: isDark ? 0.12 : 0.06,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF0B6DFF).withValues(
                  alpha: 0.12,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.pin_drop_rounded,
                  size: 20,
                  color: Color(0xFF0B6DFF),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${location.latitude.toStringAsFixed(6)}, '
                    '${location.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF10213A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FALLBACK NOTICE
  // ---------------------------------------------------------------------------

  Widget _buildFallbackNotice(bool isDark) {
    return _GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 22,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.orange,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Demo location active',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF10213A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Live GPS could not be accessed, so ProofLens is displaying its fallback prototype location.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: isDark
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAP
  // ---------------------------------------------------------------------------

  Widget _buildLiveMap(
    LocationData location,
    bool isDark,
  ) {
    return _GlassContainer(
      padding: const EdgeInsets.all(10),
      borderRadius: 28,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF142236),
                      Color(0xFF0B1828),
                    ]
                  : const [
                      Color(0xFFEAF4FF),
                      Color(0xFFDCEEFF),
                    ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _MapGridPainter(
                    isDark: isDark,
                  ),
                ),
              ),

              Positioned(
                left: 20,
                top: 20,
                child: _MapLabel(
                  icon: Icons.gps_fixed_rounded,
                  text: 'LIVE GPS',
                  isDark: isDark,
                ),
              ),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B6DFF)
                            .withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B6DFF),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0B6DFF)
                                    .withValues(alpha: 0.30),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.navigation_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.65)
                            : Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '±${location.accuracy.toStringAsFixed(1)} m',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF10213A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.52)
                        : Colors.white.withValues(alpha: 0.84),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: Color(0xFF0B6DFF),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          '${location.latitude.toStringAsFixed(5)}, '
                          '${location.longitude.toStringAsFixed(5)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF10213A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LOCATION INFORMATION
  // ---------------------------------------------------------------------------

  Widget _buildLocationInformation(
    LocationData location,
    bool isDark,
  ) {
    return _GlassContainer(
      padding: const EdgeInsets.all(18),
      borderRadius: 26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location Information',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? Colors.white
                  : const Color(0xFF10213A),
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.location_on_outlined,
            title: 'Address',
            value: location.address,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.language_rounded,
            title: 'Latitude',
            value: location.latitude.toStringAsFixed(6),
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.public_rounded,
            title: 'Longitude',
            value: location.longitude.toStringAsFixed(6),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GPS STATS
  // ---------------------------------------------------------------------------

  Widget _buildGpsStats(
    LocationData location,
    bool isDark,
  ) {
    return _GlassContainer(
      padding: const EdgeInsets.all(18),
      borderRadius: 26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GPS Details',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? Colors.white
                  : const Color(0xFF10213A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.gps_fixed_rounded,
                  label: 'Accuracy',
                  value:
                      '±${location.accuracy.toStringAsFixed(1)} m',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.height_rounded,
                  label: 'Altitude',
                  value:
                      '${location.altitude.toStringAsFixed(0)} m',
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.explore_rounded,
                  label: 'Direction',
                  value:
                      '${location.heading.toStringAsFixed(0)}°',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.satellite_alt_rounded,
                  label: 'Status',
                  value: _controller.isUsingFallback
                      ? 'Demo'
                      : 'Live',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ACCURACY
  // ---------------------------------------------------------------------------

  Widget _buildAccuracyNotice(
    LocationData location,
    bool isDark,
  ) {
    final isExcellent = location.accuracy <= 5;
    final isGood = location.accuracy > 5 &&
        location.accuracy <= 15;

    final Color statusColor;
    final String status;
    final String message;

    if (isExcellent) {
      statusColor = const Color(0xFF16C784);
      status = 'Excellent GPS';
      message =
          'Your current GPS accuracy is strong enough for precise location evidence.';
    } else if (isGood) {
      statusColor = Colors.orange;
      status = 'Good GPS';
      message =
          'Your current GPS accuracy is suitable, but moving outdoors may improve precision.';
    } else {
      statusColor = Colors.redAccent;
      status = 'Low GPS Accuracy';
      message =
          'For better location evidence, move to an open area and refresh your location.';
    }

    return _GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 22,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isExcellent || isGood
                  ? Icons.verified_rounded
                  : Icons.warning_amber_rounded,
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF10213A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: isDark
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FAMOUS PLACES NEAR ME
  // ---------------------------------------------------------------------------

  Widget _buildNearbyPreview(
    BuildContext context,
    bool isDark,
  ) {
    return _GlassContainer(
      padding: const EdgeInsets.all(18),
      borderRadius: 26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0B6DFF),
                      Color(0xFF00A9D6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Famous Places Near Me',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF10213A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Explore what is around you',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? Colors.white54
                            : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B6DFF).withValues(
                    alpha: isDark ? 0.16 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0B6DFF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CategoryChip(
                icon: Icons.photo_camera_back_rounded,
                label: 'Tourist',
                isDark: isDark,
              ),
              _CategoryChip(
                icon: Icons.local_gas_station_rounded,
                label: 'Petrol',
                isDark: isDark,
              ),
              _CategoryChip(
                icon: Icons.school_rounded,
                label: 'College',
                isDark: isDark,
              ),
              _CategoryChip(
                icon: Icons.account_balance_rounded,
                label: 'Temple',
                isDark: isDark,
              ),
              _CategoryChip(
                icon: Icons.local_hospital_rounded,
                label: 'Hospital',
                isDark: isDark,
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            'Discover tourist places, petrol bunks, colleges, schools, '
            'temples, hospitals, restaurants and other useful places '
            'around your current location.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: isDark
                  ? Colors.white60
                  : Colors.black54,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                final location = _controller.location;

                if (location == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Your current location is not available yet.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.of(context).pushNamed(
                  RouteNames.nearbyPlaces,
                  arguments: location,
                );
              },
              icon: const Icon(
                Icons.near_me_rounded,
              ),
              label: const Text(
                'Explore Places Near Me',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------

  Widget _buildActions(
    BuildContext context,
    LocationData location,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          child: _GlassActionButton(
            icon: Icons.bookmark_add_outlined,
            label: 'Save',
            isDark: isDark,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Location saved locally in the prototype.',
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _GlassActionButton(
            icon: Icons.share_rounded,
            label: 'Share',
            isDark: isDark,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Location: ${location.latitude.toStringAsFixed(6)}, '
                    '${location.longitude.toStringAsFixed(6)}',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// GLASS CONTAINER
// =============================================================================

class _GlassContainer extends StatelessWidget {
  const _GlassContainer({
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 24,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
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
          padding: padding,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.065)
                : Colors.white.withValues(alpha: 0.62),
            borderRadius:
                BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.10)
                  : Colors.white.withValues(alpha: 0.82),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.12 : 0.05,
                ),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// =============================================================================
// GLOW ORB
// =============================================================================

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 45,
        sigmaY: 45,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// =============================================================================
// INFO ROW
// =============================================================================

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF0B6DFF).withValues(
              alpha: isDark ? 0.14 : 0.07,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFF0B6DFF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white54
                      : Colors.black45,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF10213A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// STAT CARD
// =============================================================================

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.045)
            : Colors.white.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.white.withValues(alpha: 0.80),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF0B6DFF),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark
                  ? Colors.white54
                  : Colors.black45,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? Colors.white
                  : const Color(0xFF10213A),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CATEGORY CHIP
// =============================================================================

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.055)
            : Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.white.withValues(alpha: 0.80),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFF0B6DFF),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? Colors.white70
                  : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ACTION BUTTON
// =============================================================================

class _GlassActionButton extends StatelessWidget {
  const _GlassActionButton({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.60),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.85),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 19,
                color: const Color(0xFF0B6DFF),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF10213A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// MAP LABEL
// =============================================================================

class _MapLabel extends StatelessWidget {
  const _MapLabel({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  final IconData icon;
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.52)
            : Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 13,
            color: const Color(0xFF16C784),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? Colors.white
                  : const Color(0xFF10213A),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// MAP GRID
// =============================================================================

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter({
    required this.isDark,
  });

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.055)
          : const Color(0xFF0B6DFF).withValues(alpha: 0.07)
      ..strokeWidth = 2;

    final thinRoadPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.035)
          : const Color(0xFF10213A).withValues(alpha: 0.045)
      ..strokeWidth = 1;

    for (double y = 30; y < size.height; y += 42) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + 20),
        thinRoadPaint,
      );
    }

    for (double x = 25; x < size.width; x += 58) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - 20, size.height),
        thinRoadPaint,
      );
    }

    final path1 = Path()
      ..moveTo(0, size.height * 0.70)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.45,
        size.width * 0.55,
        size.height * 0.60,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.72,
        size.width,
        size.height * 0.42,
      );

    canvas.drawPath(path1, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.20, 0)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.30,
        size.width * 0.58,
        size.height * 0.40,
      )
      ..quadraticBezierTo(
        size.width * 0.80,
        size.height * 0.50,
        size.width * 0.90,
        size.height,
      );

    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}