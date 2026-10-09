import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../data/models/app_settings.dart';
import '../../../../data/repositories/settings_repository.dart';

class ImageOverlaySettingsScreen extends StatefulWidget {
  const ImageOverlaySettingsScreen({super.key});

  @override
  State<ImageOverlaySettingsScreen> createState() =>
      _ImageOverlaySettingsScreenState();
}

class _ImageOverlaySettingsScreenState
    extends State<ImageOverlaySettingsScreen> {
  final SettingsRepository _repository = SettingsRepository();

  OverlaySettings _settings = const OverlaySettings();
  AppSettings _appSettings = const AppSettings();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final appSettings = await _repository.loadSettings();

      if (!mounted) return;

      setState(() {
        _appSettings = appSettings;
        _settings = appSettings.imageOverlay;
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
      _appSettings = _appSettings.copyWith(imageOverlay: updated);
    });

    final saved = await _repository.saveSettings(_appSettings);

    if (!mounted) return;

    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save image settings')),
      );
    }
  }

  Future<void> _updateGeneral({
    bool? saveOriginalPhotos,
    bool? saveStampedPhotos,
    bool? useTrueNorth,
  }) async {
    final updated = _appSettings.copyWith(
      saveOriginalPhotos: saveOriginalPhotos,
      saveStampedPhotos: saveStampedPhotos,
      useTrueNorth: useTrueNorth,
    );

    setState(() {
      _appSettings = updated;
    });

    final saved = await _repository.saveSettings(updated);

    if (!mounted) return;

    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save general settings')),
      );
    }
  }

  Future<void> _reset() async {
    setState(() {
      _saving = true;
      _settings = const OverlaySettings();
      _appSettings = _appSettings.copyWith(
        imageOverlay: const OverlaySettings(),
      );
    });

    final saved = await _repository.saveSettings(_appSettings);

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved ? 'Image settings reset' : 'Could not reset settings',
        ),
      ),
    );
  }

  Future<void> _saveAll() async {
    setState(() {
      _saving = true;
    });

    final updated = _appSettings.copyWith(imageOverlay: _settings);
    final saved = await _repository.saveSettings(updated);

    if (!mounted) return;

    setState(() {
      _appSettings = updated;
      _saving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved
              ? 'Image settings saved successfully'
              : 'Could not save settings',
        ),
      ),
    );
  }

  Future<void> _chooseColor({
    required String title,
    required int currentColor,
    required ValueChanged<int> onSelected,
  }) async {
    const colors = <int>[
      0xCC07111F,
      0xFF07111F,
      0xFF122338,
      0xFF000000,
      0xFFFFFFFF,
      0xFF0B6DFF,
      0xFF2563EB,
      0xFF22C55E,
      0xFFF59E0B,
    ];

    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.darkSurface,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: colors.map((color) {
                  final selectedColor = color == currentColor;

                  return InkWell(
                    onTap: () => Navigator.pop(sheetContext, color),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor
                              ? AppColors.info
                              : Colors.white24,
                          width: selectedColor ? 3 : 1,
                        ),
                      ),
                      child: selectedColor
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    if (selected != null && mounted) {
      onSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Image Overlay Settings',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.info),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                _sectionTitle('LIVE PREVIEW'),
                _previewCard(),
                const SizedBox(height: 22),
                _sectionTitle('OVERLAY INFORMATION'),
                _panel(
                  children: [
                    _toggle(
                      'App Name / Logo',
                      'Show GPS LENS: MAP CAMERA branding',
                      _settings.showAppBranding,
                      (v) => _update(_settings.copyWith(showAppBranding: v)),
                    ),
                    _toggle(
                      'Full Address',
                      'Display the available location address',
                      _settings.showAddress,
                      (v) => _update(_settings.copyWith(showAddress: v)),
                    ),
                    _toggle(
                      'Latitude',
                      'Display GPS latitude',
                      _settings.showLatitude,
                      (v) => _update(_settings.copyWith(showLatitude: v)),
                    ),
                    _toggle(
                      'Longitude',
                      'Display GPS longitude',
                      _settings.showLongitude,
                      (v) => _update(_settings.copyWith(showLongitude: v)),
                    ),
                    _toggle(
                      'Date',
                      'Display capture date',
                      _settings.showDate,
                      (v) => _update(_settings.copyWith(showDate: v)),
                    ),
                    _toggle(
                      'Time & Timezone',
                      'Display capture time and timezone',
                      _settings.showTime,
                      (v) => _update(
                        _settings.copyWith(showTime: v, showTimezone: v),
                      ),
                    ),
                    _toggle(
                      'GPS Accuracy',
                      'Display estimated GPS accuracy',
                      _settings.showGpsAccuracy,
                      (v) => _update(_settings.copyWith(showGpsAccuracy: v)),
                    ),
                    _toggle(
                      'Altitude',
                      'Display altitude when available',
                      _settings.showAltitude,
                      (v) => _update(_settings.copyWith(showAltitude: v)),
                    ),
                    _toggle(
                      'Compass Direction',
                      'Display heading when available',
                      _settings.showCompassDirection,
                      (v) =>
                          _update(_settings.copyWith(showCompassDirection: v)),
                    ),
                    _toggle(
                      'Mini Map',
                      'Include a map preview',
                      _settings.showMiniMap,
                      (v) => _update(_settings.copyWith(showMiniMap: v)),
                    ),
                    _toggle(
                      'Nearby Landmark',
                      'Display a nearby landmark when known',
                      _settings.showNearbyLandmark,
                      (v) => _update(_settings.copyWith(showNearbyLandmark: v)),
                    ),
                    _toggle(
                      'Evidence ID',
                      'Display the unique evidence identifier',
                      _settings.showEvidenceId,
                      (v) => _update(_settings.copyWith(showEvidenceId: v)),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _sectionTitle('OVERLAY LAYOUT'),
                _panel(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: OverlayLayout.values.map((layout) {
                          final label = switch (layout) {
                            OverlayLayout.bottomCard => 'Bottom Card',
                            OverlayLayout.topLeft => 'Top Left',
                            OverlayLayout.topRight => 'Top Right',
                            OverlayLayout.fullInfo => 'Full Info',
                          };

                          return ChoiceChip(
                            label: Text(label),
                            selected: _settings.layout == layout,
                            onSelected: (_) =>
                                _update(_settings.copyWith(layout: layout)),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: _settings.layout == layout
                                  ? Colors.white
                                  : AppColors.darkTextSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                            backgroundColor: AppColors.darkSurface,
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _sectionTitle('APPEARANCE'),
                _panel(
                  children: [
                    _colorTile(
                      'Background Color',
                      _settings.backgroundColor,
                      () => _chooseColor(
                        title: 'Background Color',
                        currentColor: _settings.backgroundColor,
                        onSelected: (color) =>
                            _update(_settings.copyWith(backgroundColor: color)),
                      ),
                    ),
                    _colorTile(
                      'Text Color',
                      _settings.textColor,
                      () => _chooseColor(
                        title: 'Text Color',
                        currentColor: _settings.textColor,
                        onSelected: (color) =>
                            _update(_settings.copyWith(textColor: color)),
                      ),
                    ),
                    _sliderTile(
                      title: 'Font Size',
                      value: _settings.fontSize,
                      min: 10,
                      max: 22,
                      valueLabel: '${_settings.fontSize.round()} px',
                      onChanged: (v) {
                        setState(() {
                          _settings = _settings.copyWith(fontSize: v);
                        });
                      },
                      onChangeEnd: (v) =>
                          _update(_settings.copyWith(fontSize: v)),
                    ),
                    _choiceRow<OverlayTextStyle>(
                      title: 'Text Style',
                      value: _settings.textStyle,
                      options: OverlayTextStyle.values,
                      label: (style) => switch (style) {
                        OverlayTextStyle.regular => 'Regular',
                        OverlayTextStyle.medium => 'Medium',
                        OverlayTextStyle.bold => 'Bold',
                      },
                      onSelected: (value) =>
                          _update(_settings.copyWith(textStyle: value)),
                    ),
                    _choiceRow<OverlayBackgroundStyle>(
                      title: 'Background Style',
                      value: _settings.backgroundStyle,
                      options: OverlayBackgroundStyle.values,
                      label: (style) => switch (style) {
                        OverlayBackgroundStyle.solid => 'Solid',
                        OverlayBackgroundStyle.translucent => 'Translucent',
                      },
                      onSelected: (value) =>
                          _update(_settings.copyWith(backgroundStyle: value)),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _sectionTitle('IMAGE QUALITY'),
                _panel(
                  children: [
                    _choiceRow<String>(
                      title: 'Resolution',
                      value: _settings.resolution,
                      options: const ['Standard', 'High', 'Maximum'],
                      label: (value) => value,
                      onSelected: (value) =>
                          _update(_settings.copyWith(resolution: value)),
                    ),
                    _sliderTile(
                      title: 'Image Quality',
                      value: _settings.quality.toDouble(),
                      min: 50,
                      max: 100,
                      valueLabel: '${_settings.quality}%',
                      onChanged: (v) {
                        setState(() {
                          _settings = _settings.copyWith(quality: v.round());
                        });
                      },
                      onChangeEnd: (v) =>
                          _update(_settings.copyWith(quality: v.round())),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _sectionTitle('GENERAL'),
                _panel(
                  children: [
                    _toggle(
                      'Save Original Photos',
                      'Keep the original photo',
                      _appSettings.saveOriginalPhotos,
                      (v) => _updateGeneral(saveOriginalPhotos: v),
                    ),
                    _toggle(
                      'Save Stamped Photos',
                      'Save the photo with its overlay',
                      _appSettings.saveStampedPhotos,
                      (v) => _updateGeneral(saveStampedPhotos: v),
                    ),
                    _toggle(
                      'True North',
                      'Use true-north correction when available',
                      _appSettings.useTrueNorth,
                      (v) => _updateGeneral(useTrueNorth: v),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : _reset,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Reset Settings'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _saving ? null : _saveAll,
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Save Settings'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _previewCard() {
    final overlayColor =
        _settings.backgroundStyle == OverlayBackgroundStyle.solid
        ? Color(_settings.backgroundColor).withValues(alpha: 1)
        : Color(_settings.backgroundColor);

    final textColor = Color(_settings.textColor);

    final alignment = switch (_settings.layout) {
      OverlayLayout.bottomCard => Alignment.bottomCenter,
      OverlayLayout.topLeft => Alignment.topLeft,
      OverlayLayout.topRight => Alignment.topRight,
      OverlayLayout.fullInfo => Alignment.bottomCenter,
    };

    return Container(
      height: 250,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF233D55), Color(0xFF0B1827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(
            left: 18,
            top: 18,
            child: Icon(
              Icons.landscape_rounded,
              size: 85,
              color: Colors.white10,
            ),
          ),
          const Positioned(
            right: 20,
            top: 25,
            child: Icon(
              Icons.location_on_rounded,
              size: 36,
              color: AppColors.info,
            ),
          ),
          Align(
            alignment: alignment,
            child: Container(
              width: _settings.layout == OverlayLayout.fullInfo
                  ? double.infinity
                  : null,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: overlayColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: textColor,
                  fontSize: _settings.fontSize,
                  fontWeight: _settings.textStyle == OverlayTextStyle.bold
                      ? FontWeight.bold
                      : _settings.textStyle == OverlayTextStyle.medium
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_settings.showAppBranding)
                      const Text(
                        'GPS LENS: MAP CAMERA',
                        style: TextStyle(
                          color: AppColors.info,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    if (_settings.showAddress)
                      const Text('Address: Current location'),
                    if (_settings.showLatitude) const Text('LAT 12.9716°'),
                    if (_settings.showLongitude) const Text('LON 77.5946°'),
                    if (_settings.showDate)
                      Text(
                        'Date: ${DateTime.now().toLocal().toString().split(' ').first}',
                      ),
                    if (_settings.showTime)
                      Text(
                        'Time: ${TimeOfDay.now().format(context)}'
                        '${_settings.showTimezone ? ' (local)' : ''}',
                      ),
                    if (_settings.showGpsAccuracy)
                      const Text('GPS Accuracy: Awaiting GPS'),
                    if (_settings.showAltitude)
                      const Text('Altitude: Awaiting GPS'),
                    if (_settings.showCompassDirection)
                      const Text('Direction: Awaiting compass'),
                    if (_settings.showMiniMap) const Text('Mini Map'),
                    if (_settings.showNearbyLandmark)
                      const Text('Nearby landmark: Unavailable'),
                    if (_settings.showEvidenceId)
                      const Text('Evidence ID: PREVIEW'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.darkTextSecondary,
          fontSize: 11,
          letterSpacing: 1.3,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _panel({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(children: children),
    );
  }

  Widget _toggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.info,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.darkTextSecondary,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _colorTile(String title, int color, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white30),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _sliderTile({
    required String title,
    required double value,
    required double min,
    required double max,
    required String valueLabel,
    required ValueChanged<double> onChanged,
    required ValueChanged<double> onChangeEnd,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(valueLabel, style: const TextStyle(color: AppColors.info)),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            activeColor: AppColors.info,
            inactiveColor: Colors.white12,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ],
      ),
    );
  }

  Widget _choiceRow<T>({
    required String title,
    required T value,
    required List<T> options,
    required String Function(T) label,
    required ValueChanged<T> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              return ChoiceChip(
                label: Text(label(option)),
                selected: option == value,
                onSelected: (_) => onSelected(option),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.backgroundDark,
                side: BorderSide.none,
                labelStyle: TextStyle(
                  color: option == value
                      ? Colors.white
                      : AppColors.darkTextSecondary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
