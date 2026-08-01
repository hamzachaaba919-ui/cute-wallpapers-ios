import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPackageInfo());
  }

  Future<void> _loadPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    final String version = _packageInfo == null
        ? '—'
        : '${_packageInfo!.version} (${_packageInfo!.buildNumber})';

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pageHorizontalPadding,
            vertical: AppDimensions.space24,
          ),
          children: [
            Center(
              child: Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 40),
              ),
            ),
            const SizedBox(height: AppDimensions.space20),
            Center(
              child: Text(
                AppConstants.appName,
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Center(
              child: Text(
                'Version $version',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              '${AppConstants.appName} brings you a curated collection of beautiful '
              'wallpapers — cute, kawaii, animals, aesthetic, and pink — bundled '
              'right inside the app. No account, no ads, no internet connection '
              'required: everything works offline.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.6),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              'Contact us at ${AppConstants.supportEmail}',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
