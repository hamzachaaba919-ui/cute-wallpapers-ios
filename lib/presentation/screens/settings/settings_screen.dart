import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/utils/extensions.dart';
import '../../../providers/theme_provider.dart';
import '../../widgets/common/settings_tile.dart';

/// The Settings tab.
///
/// Every action here is either purely local (theme toggle) or an outbound,
/// user-triggered link (share/rate) — the app never phones home on its own.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    final bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      context.showSnack('Could not open link');
    }
  }

  Future<void> _shareApp() async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Check out ${AppConstants.appName} — beautiful wallpapers, right on your device. '
            '${AppConstants.appStoreUrl}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.only(
          top: AppDimensions.space20,
          bottom: AppDimensions.space40 + context.bottomSafeArea,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Settings', style: AppTextStyles.displayMedium),
                const SizedBox(height: AppDimensions.space4),
                Text(
                  'Make it yours',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space24),
          SettingsSection(
            title: 'Appearance',
            children: [
              SettingsTile(
                icon: Icons.dark_mode_rounded,
                label: 'Dark mode',
                subtitle: themeProvider.isDarkMode ? 'On' : 'Off',
                showChevron: false,
                trailing: Switch.adaptive(
                  value: themeProvider.isDarkMode,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                  onChanged: (value) => themeProvider.setDarkMode(enabled: value),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space20),
          SettingsSection(
            title: 'General',
            children: [
              SettingsTile(
                icon: Icons.share_rounded,
                label: 'Share app',
                onTap: _shareApp,
              ),
              SettingsTile(
                icon: Icons.star_rounded,
                label: 'Rate app',
                onTap: () => _openUrl(AppConstants.appStoreUrl),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space20),
          SettingsSection(
            title: 'About',
            children: [
              SettingsTile(
                icon: Icons.privacy_tip_rounded,
                label: 'Privacy policy',
                onTap: () => context.pushNamed(RouteNames.privacyPolicy),
              ),
              SettingsTile(
                icon: Icons.description_rounded,
                label: 'Terms of service',
                onTap: () => context.pushNamed(RouteNames.termsOfService),
              ),
              SettingsTile(
                icon: Icons.info_rounded,
                label: 'About',
                onTap: () => context.pushNamed(RouteNames.about),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
