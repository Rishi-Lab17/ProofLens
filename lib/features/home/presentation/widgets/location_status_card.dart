import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../data/models/location_data.dart';

class LocationStatusCard extends StatelessWidget {
  const LocationStatusCard({
    super.key,
    required this.location,
    required this.loading,
    required this.usingFallback,
    required this.errorMessage,
    required this.onRefresh,
  });

  final LocationData? location;
  final bool loading;
  final bool usingFallback;
  final String? errorMessage;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.075)
                : Colors.white.withValues(alpha: 0.52),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.13)
                  : Colors.white.withValues(alpha: 0.72),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.16 : 0.05,
                ),
                blurRadius: 22,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: _buildContent(context, isDark),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    if (loading && location == null) {
      return const _LoadingContent();
    }

    if (location == null) {
      return _ErrorContent(
        errorMessage: errorMessage,
        onRefresh: onRefresh,
      );
    }

    return _LocationContent(
      location: location!,
      usingFallback: usingFallback,
      isDark: isDark,
      onRefresh: onRefresh,
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.18),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
          ),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Getting your live location',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Requesting GPS location from this device...',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({
    required this.errorMessage,
    required this.onRefresh,
  });

  final String? errorMessage;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.withValues(alpha: 0.10),
            border: Border.all(
              color: Colors.orange.withValues(alpha: 0.18),
            ),
          ),
          child: const Icon(
            Icons.location_off_rounded,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location unavailable',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                errorMessage ?? 'Please enable location services.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Refresh location',
          onPressed: onRefresh,
          icon: const Icon(
            Icons.refresh_rounded,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _LocationContent extends StatelessWidget {
  const _LocationContent({
    required this.location,
    required this.usingFallback,
    required this.isDark,
    required this.onRefresh,
  });

  final LocationData location;
  final bool usingFallback;
  final bool isDark;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.20),
                ),
              ),
              child: const Icon(
                Icons.my_location_rounded,
                color: AppColors.primary,
                size: 23,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: usingFallback
                              ? Colors.orange
                              : const Color(0xFF22C55E),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        usingFallback
                            ? 'LOCATION ESTIMATE'
                            : 'LIVE LOCATION',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.72)
                              : AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    location.city.isNotEmpty
                        ? location.city
                        : location.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Refresh location',
              onPressed: onRefresh,
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.32),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.48),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.address.isNotEmpty
                    ? location.address
                    : 'Current device location',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.72)
                      : AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                '${location.latitude.toStringAsFixed(6)}, '
                '${location.longitude.toStringAsFixed(6)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.82)
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 11),
        Row(
          children: [
            Expanded(
              child: _InfoItem(
                icon: Icons.gps_fixed_rounded,
                label: 'Accuracy',
                value: '${location.accuracy.toStringAsFixed(1)} m',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoItem(
                icon: Icons.height_rounded,
                label: 'Altitude',
                value: '${location.altitude.toStringAsFixed(0)} m',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoItem(
                icon: Icons.explore_rounded,
                label: 'Heading',
                value: '${location.heading.toStringAsFixed(0)}°',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.045)
            : Colors.white.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
