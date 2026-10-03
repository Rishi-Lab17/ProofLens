import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/router/route_names.dart';
import '../../../../data/models/evidence.dart';

class ShareExportScreen extends StatelessWidget {
  const ShareExportScreen({super.key, required this.evidence});

  final Evidence evidence;

  void _copy(BuildContext context, String value, String message) {
    Clipboard.setData(ClipboardData(text: value));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Share & Export'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 18),
            _option(
              context,
              icon: Icons.image_outlined,
              title: 'Share Evidence Image',
              subtitle: 'Share the captured evidence image.',
              onTap: () => _showMessage(
                context,
                'Native image sharing will be connected during production integration.',
              ),
            ),
            _option(
              context,
              icon: Icons.description_outlined,
              title: 'Share Evidence Report',
              subtitle: 'Open the formatted report preview.',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.report,
                  arguments: evidence,
                );
              },
            ),
            _option(
              context,
              icon: Icons.fingerprint_rounded,
              title: 'Copy Evidence ID',
              subtitle: evidence.id,
              onTap: () => _copy(context, evidence.id, 'Evidence ID copied'),
            ),
            _option(
              context,
              icon: Icons.location_on_outlined,
              title: 'Copy Coordinates',
              subtitle: evidence.formattedCoordinates,
              onTap: () => _copy(
                context,
                evidence.formattedCoordinates,
                'Coordinates copied',
              ),
            ),
            _option(
              context,
              icon: Icons.link_rounded,
              title: 'Copy Location Summary',
              subtitle:
                  '${evidence.address} • ${evidence.formattedCoordinates}',
              onTap: () => _copy(
                context,
                '${evidence.address}\n'
                    '${evidence.formattedCoordinates}',
                'Location summary copied',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF1687E8).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share_rounded,
              color: Color(0xFF1687E8),
              size: 27,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share your evidence',
                  style: TextStyle(
                    color: Color(0xFF12213A),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Choose what you want to share or copy.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _option(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF1687E8).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: const Color(0xFF1687E8)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF12213A),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black45, fontSize: 11),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.black38,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
