import 'package:flutter/material.dart';

import '../../../../app/app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _metricUnits = true;
  bool _twentyFourHour = false;
  bool _locationEnabled = true;
  bool _cameraEnabled = true;
  bool _offlineMode = false;

  void _showAppearanceSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SettingsSheet(
          title: 'Appearance',
          child: Column(
            children: [
              _choiceTile(
                title: 'System default',
                icon: Icons.brightness_auto_rounded,
                selected: themeController.themeMode == ThemeMode.system,
                onTap: () {
                  themeController.setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              _choiceTile(
                title: 'Light',
                icon: Icons.light_mode_rounded,
                selected: themeController.themeMode == ThemeMode.light,
                onTap: () {
                  themeController.setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              _choiceTile(
                title: 'Dark',
                icon: Icons.dark_mode_rounded,
                selected: themeController.themeMode == ThemeMode.dark,
                onTap: () {
                  themeController.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _choiceTile({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? const Color(0xFF1687E8) : Colors.black45,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF12213A),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: Color(0xFF1687E8))
          : null,
      onTap: onTap,
    );
  }

  void _showUnitsSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SettingsSheet(
          title: 'Distance & Units',
          child: Column(
            children: [
              _choiceTile(
                title: 'Metric (km, m)',
                icon: Icons.straighten_rounded,
                selected: _metricUnits,
                onTap: () {
                  setState(() {
                    _metricUnits = true;
                  });
                  Navigator.pop(context);
                },
              ),
              _choiceTile(
                title: 'Imperial (mi, ft)',
                icon: Icons.straighten_rounded,
                selected: !_metricUnits,
                onTap: () {
                  setState(() {
                    _metricUnits = false;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTimeSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SettingsSheet(
          title: 'Time Format',
          child: Column(
            children: [
              _choiceTile(
                title: '12-hour',
                icon: Icons.schedule_rounded,
                selected: !_twentyFourHour,
                onTap: () {
                  setState(() {
                    _twentyFourHour = false;
                  });
                  Navigator.pop(context);
                },
              ),
              _choiceTile(
                title: '24-hour',
                icon: Icons.schedule_rounded,
                selected: _twentyFourHour,
                onTap: () {
                  setState(() {
                    _twentyFourHour = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy & Local Data'),
          content: const Text(
            'ProofLens prototype data is stored locally in the application session. '
            'No cloud account is required for this prototype.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _deleteLocalData() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Local Data?'),
          content: const Text(
            'This prototype action clears locally created evidence from the current session.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Local prototype data cleared.'),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'ProofLens',
      applicationVersion: 'Prototype 1.0.0',
      applicationLegalese: 'Location-aware visual evidence utility prototype.',
      children: const [
        SizedBox(height: 12),
        Text(
          'ProofLens is a cross-platform prototype for capturing, '
          'organizing and sharing location-aware visual evidence.',
        ),
        SizedBox(height: 12),
        Text(
          'Prototype data and services are simulated locally. '
          'Production GPS, mapping, routing and AI services will '
          'be integrated in a later development phase.',
        ),
      ],
    );
  }

  void _showInfo(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appearanceText = switch (themeController.themeMode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System default',
    };

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryText = isDark ? Colors.white : const Color(0xFF12213A);

    final secondaryText = isDark ? Colors.white70 : Colors.black54;

    final cardColor = isDark
        ? const Color(0xFF101C30).withValues(alpha: 0.94)
        : Colors.white.withValues(alpha: 0.95);

    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryText),
        ),

        title: Text(
          'Settings',
          style: TextStyle(color: primaryText, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          _buildProfileHeader(isDark, primaryText, secondaryText, cardColor),

          const SizedBox(height: 18),

          _section(
            title: 'Appearance',
            cardColor: cardColor,
            titleColor: primaryText,
            children: [
              _settingTile(
                icon: Icons.palette_outlined,
                title: 'Appearance',
                subtitle: appearanceText,
                primaryText: primaryText,
                secondaryText: secondaryText,
                onTap: _showAppearanceSheet,
              ),
              _settingTile(
                icon: Icons.straighten_rounded,
                title: 'Distance & Units',
                subtitle: _metricUnits ? 'Metric (km, m)' : 'Imperial (mi, ft)',
                primaryText: primaryText,
                secondaryText: secondaryText,
                onTap: _showUnitsSheet,
              ),
              _settingTile(
                icon: Icons.schedule_rounded,
                title: 'Time Format',
                subtitle: _twentyFourHour ? '24-hour' : '12-hour',
                primaryText: primaryText,
                secondaryText: secondaryText,
                onTap: _showTimeSheet,
              ),
            ],
          ),

          const SizedBox(height: 14),

          _section(
            title: 'Permissions & Device',
            cardColor: cardColor,
            titleColor: primaryText,
            children: [
              _switchTile(
                icon: Icons.location_on_outlined,
                title: 'Location',
                subtitle: 'Allow location features',
                value: _locationEnabled,
                primaryText: primaryText,
                secondaryText: secondaryText,
                onChanged: (value) {
                  setState(() {
                    _locationEnabled = value;
                  });
                },
              ),
              _switchTile(
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                subtitle: 'Allow camera capture features',
                value: _cameraEnabled,
                primaryText: primaryText,
                secondaryText: secondaryText,
                onChanged: (value) {
                  setState(() {
                    _cameraEnabled = value;
                  });
                },
              ),
              _switchTile(
                icon: Icons.wifi_off_rounded,
                title: 'Offline Mode',
                subtitle: 'Simulate limited connectivity',
                value: _offlineMode,
                primaryText: primaryText,
                secondaryText: secondaryText,
                onChanged: (value) {
                  setState(() {
                    _offlineMode = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 14),

          _section(
            title: 'Privacy',
            cardColor: cardColor,
            titleColor: primaryText,
            children: [
              _settingTile(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy & Local Data',
                subtitle: 'Manage prototype-local information',
                primaryText: primaryText,
                secondaryText: secondaryText,
                onTap: _showPrivacyDialog,
              ),
              _settingTile(
                icon: Icons.delete_outline_rounded,
                title: 'Delete Local Data',
                subtitle: 'Clear prototype evidence data',
                primaryText: primaryText,
                secondaryText: secondaryText,
                destructive: true,
                onTap: _deleteLocalData,
              ),
            ],
          ),

          const SizedBox(height: 14),

          _section(
            title: 'About',
            cardColor: cardColor,
            titleColor: primaryText,
            children: [
              _settingTile(
                icon: Icons.info_outline_rounded,
                title: 'About ProofLens',
                subtitle: 'Prototype 1.0.0',
                primaryText: primaryText,
                secondaryText: secondaryText,
                onTap: _showAbout,
              ),
              _settingTile(
                icon: Icons.description_outlined,
                title: 'Terms & Privacy',
                subtitle: 'Prototype information and limitations',
                primaryText: primaryText,
                secondaryText: secondaryText,
                onTap: () {
                  _showInfo(
                    'Terms & Privacy',
                    'This is a prototype. Production terms, privacy controls and data handling policies will be finalized before release.',
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 22),

          Center(
            child: Text(
              'ProofLens • Prototype 1.0.0',
              style: TextStyle(
                color: secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    bool isDark,
    Color primaryText,
    Color secondaryText,
    Color cardColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF1687E8),
            child: Icon(Icons.gps_fixed_rounded, color: Colors.white, size: 27),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ProofLens',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Smart location evidence',
                  style: TextStyle(color: secondaryText, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required Color cardColor,
    required Color titleColor,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 9),
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color primaryText,
    required Color secondaryText,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    final iconColor = destructive ? Colors.redAccent : const Color(0xFF1687E8);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      leading: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: destructive ? Colors.redAccent : primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: secondaryText, fontSize: 11),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: secondaryText),
      onTap: onTap,
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color primaryText,
    required Color secondaryText,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      leading: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: const Color(0xFF1687E8).withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Icon(Icons.settings_outlined, color: Color(0xFF1687E8)),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: secondaryText, fontSize: 11),
      ),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
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
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF12213A),
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
