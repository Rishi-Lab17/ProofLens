import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/location_data.dart';
import '../../../../data/models/nearby_place.dart';
import '../controllers/nearby_places_controller.dart';

class NearbyPlacesScreen extends StatefulWidget {
  const NearbyPlacesScreen({
    super.key,
    required this.location,
  });

  final LocationData location;

  @override
  State<NearbyPlacesScreen> createState() =>
      _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState
    extends State<NearbyPlacesScreen> {
  late final NearbyPlacesController _controller;

  static const categories = <_CategoryItem>[
    _CategoryItem(
      label: 'All',
      icon: Icons.explore_rounded,
    ),
    _CategoryItem(
      label: 'Tourist',
      icon: Icons.travel_explore_rounded,
    ),
    _CategoryItem(
      label: 'Petrol',
      icon: Icons.local_gas_station_rounded,
    ),
    _CategoryItem(
      label: 'College',
      icon: Icons.school_rounded,
    ),
    _CategoryItem(
      label: 'School',
      icon: Icons.menu_book_rounded,
    ),
    _CategoryItem(
      label: 'Temple',
      icon: Icons.temple_hindu_rounded,
    ),
    _CategoryItem(
      label: 'Hospital',
      icon: Icons.local_hospital_rounded,
    ),
    _CategoryItem(
      label: 'Restaurant',
      icon: Icons.restaurant_rounded,
    ),
    _CategoryItem(
      label: 'ATM',
      icon: Icons.account_balance_wallet_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = NearbyPlacesController();

    _controller.addListener(
      _onControllerChanged,
    );

    _controller.loadPlaces(
      latitude: widget.location.latitude,
      longitude: widget.location.longitude,
    );
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );

    _controller.dispose();

    super.dispose();
  }

  // ===========================================================================
  // GOOGLE MAPS - DIRECTIONS
  // ===========================================================================

  Future<void> _openGoogleMaps(
    NearbyPlace place,
  ) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${place.latitude},${place.longitude}',
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showMessage(
          'Unable to open Google Maps.',
        );
      }
    } catch (_) {
      if (mounted) {
        _showMessage(
          'Unable to open Google Maps.',
        );
      }
    }
  }

  // ===========================================================================
  // GOOGLE MAPS - PLACE
  // ===========================================================================

  Future<void> _openPlaceInMaps(
    NearbyPlace place,
  ) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=${place.latitude},${place.longitude}',
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showMessage(
          'Unable to open Google Maps.',
        );
      }
    } catch (_) {
      if (mounted) {
        _showMessage(
          'Unable to open Google Maps.',
        );
      }
    }
  }

  // ===========================================================================
  // PLACE DETAILS
  // ===========================================================================

  void _showPlaceDetails(
    NearbyPlace place,
  ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _PlaceDetailsSheet(
          place: place,
          distance: _controller.distanceText(place),
          eta: _controller.etaText(place),
          isDark: isDark,
          onDirections: () {
            Navigator.of(context).pop();
            _openGoogleMaps(place);
          },
          onOpenMaps: () {
            Navigator.of(context).pop();
            _openPlaceInMaps(place);
          },
        );
      },
    );
  }

  // ===========================================================================
  // MESSAGE
  // ===========================================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Places Near Me',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return _controller.loadPlaces(
              latitude: widget.location.latitude,
              longitude: widget.location.longitude,
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(
              16,
              4,
              16,
              32,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildHeader(isDark),
                const SizedBox(height: 18),
                _buildCategories(isDark),
                const SizedBox(height: 20),
                _buildResults(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(bool isDark) {
    return _GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 28,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0B6DFF).withValues(
                alpha: isDark ? 0.16 : 0.09,
              ),
            ),
            child: const Icon(
              Icons.near_me_rounded,
              color: Color(0xFF0B6DFF),
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Around your location',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF10213A),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.location.coordinates,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (_controller.loading)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CATEGORIES
  // ===========================================================================

  Widget _buildCategories(bool isDark) {
    return SizedBox(
      height: 94,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];

          final selected =
              category.label ==
                  _controller.selectedCategory;

          return _CategoryButton(
            item: category,
            selected: selected,
            isDark: isDark,
            onTap: () {
              _controller.selectCategory(
                category.label,
              );
            },
          );
        },
      ),
    );
  }

  // ===========================================================================
  // RESULTS
  // ===========================================================================

  Widget _buildResults(bool isDark) {
    if (_controller.loading &&
        !_controller.hasPlaces) {
      return const _LoadingPlaces();
    }

    if (_controller.errorMessage != null) {
      return _ErrorPlaces(
        message: _controller.errorMessage!,
        onRetry: () {
          _controller.loadPlaces(
            latitude: widget.location.latitude,
            longitude: widget.location.longitude,
          );
        },
      );
    }

    if (!_controller.hasPlaces) {
      return const _EmptyPlaces();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _controller.selectedCategory == 'All'
                    ? 'Nearby places'
                    : '${_controller.selectedCategory}s nearby',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF10213A),
                ),
              ),
            ),
            Text(
              '${_controller.places.length} places',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? Colors.white54
                    : Colors.black45,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._controller.places.map(
          (place) => Padding(
            padding: const EdgeInsets.only(
              bottom: 11,
            ),
            child: _PlaceCard(
              place: place,
              distance:
                  _controller.distanceText(place),
              eta: _controller.etaText(place),
              isDark: isDark,
              onTap: () {
                _showPlaceDetails(place);
              },
              onDirections: () {
                _openGoogleMaps(place);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// CATEGORY MODEL
// =============================================================================

class _CategoryItem {
  const _CategoryItem({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

// =============================================================================
// CATEGORY BUTTON
// =============================================================================

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.item,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final _CategoryItem item;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 220,
        ),
        width: 82,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? const Color(0xFF0B6DFF).withValues(
                  alpha: isDark ? 0.20 : 0.11,
                )
              : isDark
                  ? Colors.white.withValues(
                      alpha: 0.06,
                    )
                  : Colors.white.withValues(
                      alpha: 0.55,
                    ),
          border: Border.all(
            color: selected
                ? const Color(0xFF0B6DFF)
                : isDark
                    ? Colors.white.withValues(
                        alpha: 0.10,
                      )
                    : Colors.white.withValues(
                        alpha: 0.70,
                      ),
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 23,
              color: selected
                  ? const Color(0xFF0B6DFF)
                  : isDark
                      ? Colors.white70
                      : Colors.black54,
            ),
            const SizedBox(height: 7),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: selected
                    ? const Color(0xFF0B6DFF)
                    : isDark
                        ? Colors.white70
                        : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PLACE CARD
// =============================================================================

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.place,
    required this.distance,
    required this.eta,
    required this.isDark,
    required this.onTap,
    required this.onDirections,
  });

  final NearbyPlace place;
  final String distance;
  final String eta;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDirections;

  IconData get _icon {
    switch (place.category) {
      case 'Tourist':
        return Icons.travel_explore_rounded;
      case 'Petrol':
        return Icons.local_gas_station_rounded;
      case 'College':
        return Icons.school_rounded;
      case 'School':
        return Icons.menu_book_rounded;
      case 'Temple':
        return Icons.temple_hindu_rounded;
      case 'Hospital':
        return Icons.local_hospital_rounded;
      case 'Restaurant':
        return Icons.restaurant_rounded;
      case 'ATM':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _GlassContainer(
      padding: const EdgeInsets.all(15),
      borderRadius: 23,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(17),
                color: const Color(0xFF0B6DFF)
                    .withValues(
                  alpha: isDark ? 0.15 : 0.08,
                ),
              ),
              child: Icon(
                _icon,
                color: const Color(0xFF0B6DFF),
                size: 26,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF10213A),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    place.category,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0B6DFF),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    place.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? Colors.white54
                          : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.near_me_rounded,
                        size: 13,
                        color: Color(0xFF22A06B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: Color(0xFF8B5CF6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        eta,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _DirectionsButton(
              onPressed: onDirections,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// DIRECTIONS BUTTON
// =============================================================================

class _DirectionsButton extends StatelessWidget {
  const _DirectionsButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0B6DFF),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: const SizedBox(
          width: 43,
          height: 43,
          child: Icon(
            Icons.directions_rounded,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PLACE DETAILS SHEET
// =============================================================================

class _PlaceDetailsSheet extends StatelessWidget {
  const _PlaceDetailsSheet({
    required this.place,
    required this.distance,
    required this.eta,
    required this.isDark,
    required this.onDirections,
    required this.onOpenMaps,
  });

  final NearbyPlace place;
  final String distance;
  final String eta;
  final bool isDark;
  final VoidCallback onDirections;
  final VoidCallback onOpenMaps;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                22,
                12,
                22,
                24,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF101B2A)
                        .withValues(alpha: 0.94)
                    : Colors.white.withValues(
                        alpha: 0.94,
                      ),
                borderRadius:
                    BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white24
                            : Colors.black12,
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    place.name,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF10213A),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    place.category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B6DFF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    place.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _InfoRow(
                    icon: Icons.location_on_rounded,
                    text: place.address,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.near_me_rounded,
                    text: '$distance away',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.schedule_rounded,
                    text: 'Estimated $eta',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onDirections,
                          icon: const Icon(
                            Icons.directions_rounded,
                          ),
                          label: const Text(
                            'Directions',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onOpenMaps,
                          icon: const Icon(
                            Icons.map_rounded,
                          ),
                          label: const Text(
                            'Open Maps',
                          ),
                        ),
                      ),
                    ],
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

// =============================================================================
// INFO ROW
// =============================================================================

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  final IconData icon;
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF0B6DFF),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white70
                  : Colors.black54,
            ),
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
    required this.padding,
    required this.borderRadius,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(borderRadius),
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
                ? Colors.white.withValues(
                    alpha: 0.07,
                  )
                : Colors.white.withValues(
                    alpha: 0.62,
                  ),
            borderRadius:
                BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(
                      alpha: 0.12,
                    )
                  : Colors.white.withValues(
                      alpha: 0.75,
                    ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.14 : 0.05,
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

// =============================================================================
// LOADING
// =============================================================================

class _LoadingPlaces extends StatelessWidget {
  const _LoadingPlaces();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
            ),
            SizedBox(height: 18),
            Text(
              'Finding places near you...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// EMPTY
// =============================================================================

class _EmptyPlaces extends StatelessWidget {
  const _EmptyPlaces();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.location_searching_rounded,
              size: 54,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Text(
              'No places found',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Try another category.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ERROR
// =============================================================================

class _ErrorPlaces extends StatelessWidget {
  const _ErrorPlaces({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 52,
              color: Colors.orange,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}