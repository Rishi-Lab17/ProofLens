import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../data/models/evidence.dart';
import '../../../../data/repositories/evidence_repository.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Evidence> _filteredEvidence() {
    final evidence = EvidenceRepository.instance.all;

    return evidence.where((item) {
      final matchesSearch =
          _query.isEmpty ||
          item.id.toLowerCase().contains(_query) ||
          item.address.toLowerCase().contains(_query) ||
          item.formattedCoordinates.toLowerCase().contains(_query);

      final matchesFilter = switch (_filter) {
        'Today' => _isToday(item.capturedAt),
        'This Week' => _isThisWeek(item.capturedAt),
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isThisWeek(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    return difference >= 0 && difference < 7;
  }

  void _openEvidence(Evidence evidence) {
    Navigator.pushNamed(
      context,
      RouteNames.evidenceDetails,
      arguments: evidence,
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Filter Evidence',
                style: TextStyle(
                  color: Color(0xFF12213A),
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              _filterOption('All'),
              _filterOption('Today'),
              _filterOption('This Week'),
            ],
          ),
        );
      },
    );
  }

  Widget _filterOption(String value) {
    final selected = _filter == value;

    return ListTile(
      leading: Icon(
        selected
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_off_rounded,
        color: selected ? const Color(0xFF1687E8) : Colors.black38,
      ),
      title: Text(
        value,
        style: const TextStyle(
          color: Color(0xFF12213A),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        setState(() {
          _filter = value;
        });

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final evidence = _filteredEvidence();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Evidence History'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            tooltip: 'Filter',
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search evidence, location or ID...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: const Icon(Icons.close_rounded),
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _summaryChip('${evidence.length} evidence'),
                const SizedBox(width: 8),
                _summaryChip(_filter),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: evidence.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 30),
                    itemCount: evidence.length,
                    itemBuilder: (context, index) {
                      return _evidenceCard(evidence[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _summaryChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1687E8),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _evidenceCard(Evidence evidence) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(22),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _openEvidence(evidence),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  evidence.imagePath,
                  width: 82,
                  height: 82,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF15945B),
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            evidence.id,
                            style: const TextStyle(
                              color: Color(0xFF12213A),
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      evidence.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.gps_fixed_rounded,
                          size: 14,
                          color: Color(0xFF1687E8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          evidence.formattedAccuracy,
                          style: const TextStyle(
                            color: Color(0xFF1687E8),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 9),
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: Colors.black38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(evidence.capturedAt),
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.photo_library_outlined,
                color: Color(0xFF1687E8),
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No evidence yet',
              style: TextStyle(
                color: Color(0xFF12213A),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Capture your first location-aware evidence to see it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.camera);
              },
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('Capture Evidence'),
            ),
          ],
        ),
      ),
    );
  }
}
