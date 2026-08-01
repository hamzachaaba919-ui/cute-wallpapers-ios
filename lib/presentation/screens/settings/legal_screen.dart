import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/legal_content.dart';
import '../../../core/utils/extensions.dart';

/// Structured, easy-to-read reader for the Privacy Policy and Terms of
/// Service. Renders a [LegalDocument]'s heading/paragraph structure with
/// the app's own typography and spacing scale — a clear "Last updated"
/// line, an intro paragraph, then each section with its own heading and
/// generous breathing room — rather than one long block of plain text.
class LegalScreen extends StatelessWidget {
  const LegalScreen({required this.title, required this.document, super.key});

  final String title;
  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pageHorizontalPadding,
            vertical: AppDimensions.space24,
          ),
          children: [
            Text(
              'Last updated: ${document.lastUpdated}',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              document.intro,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            for (final LegalSection section in document.sections) ...[
              const SizedBox(height: AppDimensions.space28),
              Text(section.heading, style: AppTextStyles.titleLarge),
              const SizedBox(height: AppDimensions.space8),
              for (int i = 0; i < section.paragraphs.length; i++) ...[
                if (i > 0) const SizedBox(height: AppDimensions.space12),
                Text(
                  section.paragraphs[i],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ],
            SizedBox(height: AppDimensions.space40 + context.bottomSafeArea),
          ],
        ),
      ),
    );
  }
}
