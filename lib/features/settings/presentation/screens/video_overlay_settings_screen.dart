import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../data/models/app_settings.dart';
import '../../../../data/repositories/settings_repository.dart';

class VideoOverlaySettingsScreen extends StatefulWidget {
  const VideoOverlaySettingsScreen({super.key});

  @override
  State<VideoOverlaySettingsScreen> createState() =>
      _VideoOverlaySettingsScreenState();
}

class _VideoOverlaySettingsScreenState
    extends State<VideoOverlaySettingsScreen> {
  final SettingsRepository _repository = SettingsRepository();

  AppSettings _appSettings = const AppSettings();
  OverlaySettings _settings = const OverlaySettings(
    resolution: '1080p',
    quality: 85,
  );

  bool _loading = true;
  bool _saving = false;

  static const Color _panelColor = Color(0xFF102137);
  static const Color _panelBorder = Color(0xFF243A53);
  static const Color _mutedText = Color(0xFF9AAEC5);
  static const Color _blue = Color(0xFF0B6DFF);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final loaded = await _repository.loadSettings();

      if (!mounted) return;

      setState(() {
        _appSettings = loaded;
        _settings = loaded.videoOverlay;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _update(OverlaySettings updated) async {
    setState(() {
      _settings = updated;
      _appSettings = _appSettings.copyWith(videoOverlay: updated);
    });

    await _persist(showMessage: false);
  }

  Future<void> _updateGeneral({
    bool? saveOriginalVideos,
    bool? saveStampedVideos,
    bool? useTrueNorth,
  }) async {
    setState(() {
      _appSettings = _appSettings.copyWith(
        saveOriginalVideos: saveOriginalVideos,
        saveStampedVideos: saveStampedVideos,
        useTrueNorth: useTrueNorth,
      );
    });

    await _persist(showMessage: false);
  }

  Future<void> _persist({required bool showMessage}) async {
    try {
      final success = await _repository.saveSettings(_appSettings);

      if (!mounted || !showMessage) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Video settings saved.' : 'Could not save settings.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted || !showMessage) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save video settings.')),
      );
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _saving = true);

    try {
      final success = await _repository.saveSettings(_appSettings);

      if (!mounted) return;

      setState(() => _saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Video overlay settings saved successfully.'
                : 'Unable to save settings.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() => _saving = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to save settings.')));
    }
  }

  Future<void> _resetSettings() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _panelColor,
        title: const Text(
          'Reset video settings?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Your video overlay preferences will return to their defaults.',
          style: TextStyle(color: _mutedText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _settings = const OverlaySettings(resolution: '1080p', quality: 85);

      _appSettings = _appSettings.copyWith(
        videoOverlay: _settings,
        saveOriginalVideos: true,
        saveStampedVideos: true,
        useTrueNorth: true,
      );
    });

    await _persist(showMessage: true);
  }

  Future<void> _chooseColor({
    required String title,
    required int currentColor,
    required ValueChanged<int> onSelected,
  }) async {
    const colors = <int>[
      0xCC07111F,
      0xFF07111F,
      0xCC102137,
      0xCC000000,
      0xFFFFFFFF,
      0xFF0B6DFF,
      0xFF22C55E,
      0xFFFFC107,
      0xFFFF5252,
      0xFFB388FF,
    ];

    final selected = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _panelColor,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((color) {
            return InkWell(
              onTap: () => Navigator.pop(dialogContext, color),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Color(color),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color == currentColor ? _blue : _panelBorder,
                    width: color == currentColor ? 3 : 1,
                  ),
                ),
                child: color == currentColor
                    ? Icon(
                        Icons.check,
                        color: color == 0xFFFFFFFF
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );

    if (selected != null && mounted) {
      onSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Video Overlay Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Reset settings',
            onPressed: _resetSettings,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            _introCard(),
            const SizedBox(height: 18),
            _sectionTitle('LIVE PREVIEW', Icons.preview_rounded),
            const SizedBox(height: 10),
            _previewCard(),
            const SizedBox(height: 22),
            _sectionTitle('OVERLAY INFORMATION', Icons.info_outline_rounded),
            const SizedBox(height: 10),
            _informationCard(),
            const SizedBox(height: 22),
            _sectionTitle('OVERLAY LAYOUT', Icons.dashboard_customize_rounded),
            const SizedBox(height: 10),
            _layoutCard(),
            const SizedBox(height: 22),
            _sectionTitle('APPEARANCE', Icons.palette_outlined),
            const SizedBox(height: 10),
            _appearanceCard(isDark),
            const SizedBox(height: 22),
            _sectionTitle('VIDEO QUALITY', Icons.video_settings_rounded),
            const SizedBox(height: 10),
            _qualityCard(),
            const SizedBox(height: 22),
            _sectionTitle('GENERAL', Icons.tune_rounded),
            const SizedBox(height: 10),
            _generalCard(),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _resetSettings,
              icon: const Icon(Icons.restore_rounded),
              label: const Text('Reset Settings'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: isDark ? Colors.white : AppColors.textPrimary,
                side: BorderSide(
                  color: isDark ? _panelBorder : AppColors.dividerLight,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _saving ? null : _saveSettings,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(_saving ? 'Saving...' : 'Save Settings'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _introCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF123B70), Color(0xFF102137)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _panelBorder),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFF2457A7),
            child: Icon(Icons.videocam_rounded, color: Colors.white, size: 28),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GPS LENS: MAP CAMERA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Customize the location stamp for your videos.',
                  style: TextStyle(color: Color(0xFFCAD8EA), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _blue, size: 19),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _previewCard() {
    final bgColor = Color(_settings.backgroundColor);
    final foreground = Color(_settings.textColor);
    final alignment = switch (_settings.layout) {
      OverlayLayout.bottomCard => Alignment.bottomCenter,
      OverlayLayout.topLeft => Alignment.topLeft,
      OverlayLayout.topRight => Alignment.topRight,
      OverlayLayout.fullInfo => Alignment.center,
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _panelColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _panelBorder),
      ),
      child: Column(
        children: [
          Container(
            height: 235,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF26384B),
              borderRadius: BorderRadius.circular(13),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=800',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: alignment,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: _previewOverlay(bgColor, foreground),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.info_outline, size: 15, color: _mutedText),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Illustrative preview. Actual GPS data appears during capture when available.',
                  style: TextStyle(color: _mutedText, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _previewOverlay(Color bgColor, Color foreground) {
    final rows = <Widget>[];

    void addRow(bool visible, String label, String value) {
      if (!visible) return;

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            '$label: $value',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: foreground,
              fontSize: _settings.fontSize.clamp(9, 17),
              fontWeight: _fontWeight,
            ),
          ),
        ),
      );
    }

    if (_settings.showAppBranding) {
      rows.add(
        Text(
          'GPS LENS: MAP CAMERA',
          style: TextStyle(
            color: foreground,
            fontWeight: FontWeight.bold,
            fontSize: _settings.fontSize.clamp(9, 17),
          ),
        ),
      );
    }

    addRow(_settings.showAddress, 'Address', 'Preview location');
    addRow(_settings.showLatitude, 'Latitude', '12.9716');
    addRow(_settings.showLongitude, 'Longitude', '77.5946');
    addRow(_settings.showDate, 'Date', '2026-10-09');
    addRow(_settings.showTime, 'Time', '10:30 AM IST');
    addRow(_settings.showGpsAccuracy, 'GPS Accuracy', 'Awaiting GPS');
    addRow(_settings.showAltitude, 'Altitude', '—');
    addRow(_settings.showCompassDirection, 'Direction', '—');
    addRow(_settings.showNearbyLandmark, 'Landmark', 'Not available');
    addRow(_settings.showEvidenceId, 'Evidence ID', 'PREVIEW');

    if (_settings.showMiniMap) {
      rows.add(
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Row(
            children: [
              Icon(Icons.map_outlined, size: 14, color: _blue),
              SizedBox(width: 5),
              Text(
                'Mini map preview',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 290),
      padding: EdgeInsets.all(
        _settings.layout == OverlayLayout.fullInfo ? 14 : 10,
      ),
      decoration: BoxDecoration(
        color: _settings.backgroundStyle == OverlayBackgroundStyle.solid
            ? bgColor.withValues(alpha: 1)
            : bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _blue.withValues(alpha: 0.6)),
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: foreground),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: rows,
        ),
      ),
    );
  }

  FontWeight get _fontWeight => switch (_settings.textStyle) {
    OverlayTextStyle.regular => FontWeight.normal,
    OverlayTextStyle.medium => FontWeight.w500,
    OverlayTextStyle.bold => FontWeight.bold,
  };

  Widget _informationCard() {
    return _panel(
      child: Column(
        children: [
          _switchRow(
            'App Name / Logo',
            'Show GPS LENS branding',
            Icons.verified_outlined,
            _settings.showAppBranding,
            (value) => _update(_settings.copyWith(showAppBranding: value)),
          ),
          _divider(),
          _switchRow(
            'Full Address',
            'Display available street and area details',
            Icons.location_on_outlined,
            _settings.showAddress,
            (value) => _update(_settings.copyWith(showAddress: value)),
          ),
          _divider(),
          _switchRow(
            'Latitude',
            'Show the recorded latitude',
            Icons.my_location_rounded,
            _settings.showLatitude,
            (value) => _update(_settings.copyWith(showLatitude: value)),
          ),
          _divider(),
          _switchRow(
            'Longitude',
            'Show the recorded longitude',
            Icons.public_rounded,
            _settings.showLongitude,
            (value) => _update(_settings.copyWith(showLongitude: value)),
          ),
          _divider(),
          _switchRow(
            'Date',
            'Show the recording date',
            Icons.calendar_month_rounded,
            _settings.showDate,
            (value) => _update(_settings.copyWith(showDate: value)),
          ),
          _divider(),
          _switchRow(
            'Time & Timezone',
            'Show time and timezone when available',
            Icons.schedule_rounded,
            _settings.showTime,
            (value) => _update(
              _settings.copyWith(showTime: value, showTimezone: value),
            ),
          ),
          _divider(),
          _switchRow(
            'GPS Accuracy',
            'Show location accuracy in metres',
            Icons.gps_fixed_rounded,
            _settings.showGpsAccuracy,
            (value) => _update(_settings.copyWith(showGpsAccuracy: value)),
          ),
          _divider(),
          _switchRow(
            'Altitude',
            'Show elevation when available',
            Icons.terrain_rounded,
            _settings.showAltitude,
            (value) => _update(_settings.copyWith(showAltitude: value)),
          ),
          _divider(),
          _switchRow(
            'Compass Direction',
            'Display the direction indicator',
            Icons.explore_outlined,
            _settings.showCompassDirection,
            (value) => _update(_settings.copyWith(showCompassDirection: value)),
          ),
          _divider(),
          _switchRow(
            'Mini Map',
            'Reserve space for a location map',
            Icons.map_outlined,
            _settings.showMiniMap,
            (value) => _update(_settings.copyWith(showMiniMap: value)),
          ),
          _divider(),
          _switchRow(
            'Nearby Landmark',
            'Show a nearby place when identified',
            Icons.place_outlined,
            _settings.showNearbyLandmark,
            (value) => _update(_settings.copyWith(showNearbyLandmark: value)),
          ),
          _divider(),
          _switchRow(
            'Evidence ID',
            'Show the recording evidence identifier',
            Icons.fingerprint_rounded,
            _settings.showEvidenceId,
            (value) => _update(_settings.copyWith(showEvidenceId: value)),
          ),
        ],
      ),
    );
  }

  Widget _layoutCard() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose where the location stamp appears.',
            style: TextStyle(color: _mutedText, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              _layoutChoice(
                OverlayLayout.bottomCard,
                'Bottom Card',
                Icons.vertical_align_bottom_rounded,
              ),
              _layoutChoice(
                OverlayLayout.topLeft,
                'Top Left',
                Icons.north_west_rounded,
              ),
              _layoutChoice(
                OverlayLayout.topRight,
                'Top Right',
                Icons.north_east_rounded,
              ),
              _layoutChoice(
                OverlayLayout.fullInfo,
                'Full Info',
                Icons.fullscreen_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _layoutChoice(OverlayLayout layout, String label, IconData icon) {
    final selected = _settings.layout == layout;

    return ChoiceChip(
      selected: selected,
      onSelected: (_) => _update(_settings.copyWith(layout: layout)),
      avatar: Icon(icon, size: 17, color: selected ? Colors.white : _mutedText),
      label: Text(label),
      selectedColor: _blue,
      backgroundColor: const Color(0xFF162B42),
      labelStyle: TextStyle(
        color: selected ? Colors.white : _mutedText,
        fontSize: 12,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(color: selected ? _blue : _panelBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _appearanceCard(bool isDark) {
    return _panel(
      child: Column(
        children: [
          _settingAction(
            icon: Icons.format_color_fill_rounded,
            title: 'Background Colour',
            subtitle: 'Choose the overlay background',
            trailing: _colorCircle(_settings.backgroundColor),
            onTap: () => _chooseColor(
              title: 'Background Colour',
              currentColor: _settings.backgroundColor,
              onSelected: (color) =>
                  _update(_settings.copyWith(backgroundColor: color)),
            ),
          ),
          _divider(),
          _settingAction(
            icon: Icons.format_color_text_rounded,
            title: 'Text Colour',
            subtitle: 'Choose the overlay text colour',
            trailing: _colorCircle(_settings.textColor),
            onTap: () => _chooseColor(
              title: 'Text Colour',
              currentColor: _settings.textColor,
              onSelected: (color) =>
                  _update(_settings.copyWith(textColor: color)),
            ),
          ),
          _divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.text_fields_rounded,
                      color: _blue,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Font Size',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '${_settings.fontSize.round()} px',
                      style: const TextStyle(
                        color: _mutedText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _settings.fontSize.clamp(10, 20),
                  min: 10,
                  max: 20,
                  divisions: 10,
                  activeColor: _blue,
                  onChanged: (value) =>
                      _update(_settings.copyWith(fontSize: value)),
                ),
              ],
            ),
          ),
          _divider(),
          _settingAction(
            icon: Icons.format_bold_rounded,
            title: 'Text Style',
            subtitle: 'Choose regular, medium or bold',
            trailing: DropdownButton<OverlayTextStyle>(
              value: _settings.textStyle,
              dropdownColor: _panelColor,
              underline: const SizedBox.shrink(),
              items: OverlayTextStyle.values.map((style) {
                return DropdownMenuItem(
                  value: style,
                  child: Text(switch (style) {
                    OverlayTextStyle.regular => 'Regular',
                    OverlayTextStyle.medium => 'Medium',
                    OverlayTextStyle.bold => 'Bold',
                  }, style: const TextStyle(color: Colors.white, fontSize: 12)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _update(_settings.copyWith(textStyle: value));
                }
              },
            ),
            onTap: () {},
          ),
          _divider(),
          _settingAction(
            icon: Icons.layers_rounded,
            title: 'Background Style',
            subtitle: 'Solid or translucent background',
            trailing: DropdownButton<OverlayBackgroundStyle>(
              value: _settings.backgroundStyle,
              dropdownColor: _panelColor,
              underline: const SizedBox.shrink(),
              items: OverlayBackgroundStyle.values.map((style) {
                return DropdownMenuItem(
                  value: style,
                  child: Text(
                    style == OverlayBackgroundStyle.solid
                        ? 'Solid'
                        : 'Translucent',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _update(_settings.copyWith(backgroundStyle: value));
                }
              },
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _qualityCard() {
    const resolutions = ['720p', '1080p', '2K', '4K'];

    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recording Resolution',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          const Text(
            'Available resolutions depend on your device camera.',
            style: TextStyle(color: _mutedText, fontSize: 11),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: resolutions.map((resolution) {
              final selected = _settings.resolution == resolution;

              return ChoiceChip(
                label: Text(resolution),
                selected: selected,
                onSelected: (_) =>
                    _update(_settings.copyWith(resolution: resolution)),
                selectedColor: _blue,
                backgroundColor: const Color(0xFF162B42),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : _mutedText,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(color: selected ? _blue : _panelBorder),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.high_quality_rounded, color: _blue),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Video Quality',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '${_settings.quality}%',
                style: const TextStyle(
                  color: _mutedText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: _settings.quality.clamp(50, 100).toDouble(),
            min: 50,
            max: 100,
            divisions: 10,
            activeColor: _blue,
            onChanged: (value) =>
                _update(_settings.copyWith(quality: value.round())),
          ),
          const Text(
            'Higher quality can use more storage. Actual recording settings depend on device support.',
            style: TextStyle(color: _mutedText, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _generalCard() {
    return _panel(
      child: Column(
        children: [
          _switchRow(
            'Save Original Videos',
            'Keep a copy without the location stamp',
            Icons.video_file_outlined,
            _appSettings.saveOriginalVideos,
            (value) => _updateGeneral(saveOriginalVideos: value),
          ),
          _divider(),
          _switchRow(
            'Save Stamped Videos',
            'Keep a copy with the location overlay',
            Icons.video_camera_back_outlined,
            _appSettings.saveStampedVideos,
            (value) => _updateGeneral(saveStampedVideos: value),
          ),
          _divider(),
          _switchRow(
            'True North',
            'Use true-north direction when sensor data permits',
            Icons.explore_rounded,
            _appSettings.useTrueNorth,
            (value) => _updateGeneral(useTrueNorth: value),
          ),
        ],
      ),
    );
  }

  Widget _panel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _panelBorder),
      ),
      child: child,
    );
  }

  Widget _switchRow(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: _blue.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: _blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: _mutedText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: value,
            activeTrackColor: _blue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _settingAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: _blue, size: 21),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _mutedText, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _colorCircle(int color) {
    return Container(
      width: 29,
      height: 29,
      decoration: BoxDecoration(
        color: Color(color),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white54),
      ),
      child: const Icon(Icons.edit, color: Colors.white, size: 13),
    );
  }

  Widget _divider() {
    return const Divider(height: 12, color: _panelBorder);
  }
}
