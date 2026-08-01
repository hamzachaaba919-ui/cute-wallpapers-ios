import 'package:flutter/foundation.dart';

import 'app_constants.dart';

/// A single labelled section within a legal document — a heading plus one
/// or more body paragraphs.
@immutable
class LegalSection {
  const LegalSection({required this.heading, required this.paragraphs});

  final String heading;
  final List<String> paragraphs;
}

/// A full legal document: a "last updated" date, a short introduction, and
/// an ordered list of sections. [LegalScreen] renders this structure with
/// proper heading/paragraph typography rather than one long block of text.
@immutable
class LegalDocument {
  const LegalDocument({
    required this.lastUpdated,
    required this.intro,
    required this.sections,
  });

  final String lastUpdated;
  final String intro;
  final List<LegalSection> sections;
}

/// Static legal copy shown in-app so the Privacy Policy and Terms of
/// Service are always available, even fully offline. Written to reflect
/// exactly what this app does: no account, no backend, no analytics, no
/// advertising, and no data collection of any kind.
abstract final class LegalContent {
  /// Kept in one place so both documents always show the same date.
  static const String _lastUpdated = 'August 2, 2026';

  static const LegalDocument privacyPolicy = LegalDocument(
    lastUpdated: _lastUpdated,
    intro:
        'This Privacy Policy explains how ${AppConstants.appName} ("the app", '
        '"we", "us") handles information when you use it. ${AppConstants.appName} '
        'is built to work entirely offline, with no account, no backend server, '
        'no analytics, and no advertising — so there is very little for this '
        'policy to cover, and that is by design.',
    sections: [
      LegalSection(
        heading: '1. Information We Collect',
        paragraphs: [
          '${AppConstants.appName} does not collect any personal information. '
              'The app does not ask you to create an account and does not request '
              'your name, email address, location, or contacts. It does not connect '
              'to the internet to send or receive data of any kind.',
          'Every wallpaper in the catalog is bundled inside the app itself, so '
              'browsing, searching, and favoriting wallpapers all happen entirely '
              'on your device and never leave it.',
        ],
      ),
      LegalSection(
        heading: '2. Local Storage & Data Retention',
        paragraphs: [
          'The only information the app stores is kept entirely on your device, '
              "using your operating system's standard local app storage:",
          '•  Your favorited wallpapers\n'
              '•  Your light/dark theme preference\n'
              '•  Your recent search terms',
          'None of this information is transmitted anywhere or visible to us. '
              "It is automatically and permanently deleted if you clear the app's "
              'storage or uninstall the app.',
        ],
      ),
      LegalSection(
        heading: '3. Permissions We Request',
        paragraphs: [
          'The app requests one device permission, used only to complete an '
              'action you explicitly choose to perform:',
          "•  Photos access (add only) — when you tap \"Save Wallpaper,\" this "
              "lets the app add the chosen image to your Photos library so you "
              "can then set it from the Photos app. The app can only add "
              "photos this way — it cannot see, browse, or modify anything "
              "else already in your library.",
          'No permission is ever used to collect, monitor, or transmit data in '
              'the background.',
        ],
      ),
      LegalSection(
        heading: '4. Analytics & Advertising',
        paragraphs: [
          '${AppConstants.appName} contains no analytics software, no crash-'
              'reporting tools, no advertising networks, and no tracking pixels. '
              'We have no visibility into how you use the app and no way to '
              'identify you or your device.',
        ],
      ),
      LegalSection(
        heading: '5. Third-Party Services',
        paragraphs: [
          '${AppConstants.appName} does not integrate with any third-party '
              'services, APIs, or cloud platforms. Because the app never connects '
              'to the internet on its own, no data is ever shared with third '
              'parties.',
        ],
      ),
      LegalSection(
        heading: "6. Children's Privacy",
        paragraphs: [
          '${AppConstants.appName} does not knowingly collect personal '
              'information from anyone, including children under the age of 13 '
              '(or the equivalent minimum age in your region). Because the app '
              'collects no personal information from any user, this applies '
              'equally to users of every age.',
        ],
      ),
      LegalSection(
        heading: '7. Data Security',
        paragraphs: [
          'Since no personal information ever leaves your device, there is no '
              'transmission for us to secure. The security of any locally stored '
              'data — your favorites and preferences — depends on the security of '
              'your own device, such as its passcode or biometric lock.',
        ],
      ),
      LegalSection(
        heading: '8. Your Rights and Choices',
        paragraphs: [
          'Because ${AppConstants.appName} does not collect or store any data '
              'outside your device, there is no external account, profile, or '
              'record for us to access, correct, export, or delete on your '
              'behalf. You remain in full control at all times:',
          '•  To remove your favorites or preferences, clear the app\'s storage '
              'from your device settings.\n'
              '•  Uninstalling the app permanently removes all locally stored data '
              'associated with it.',
        ],
      ),
      LegalSection(
        heading: '9. International Users',
        paragraphs: [
          'Because no data is ever collected or transmitted, ${AppConstants.appName} '
              'does not transfer information across borders, and this policy applies '
              'the same way no matter where you use the app.',
        ],
      ),
      LegalSection(
        heading: '10. Changes to This Policy',
        paragraphs: [
          'We may update this Privacy Policy from time to time — for example, if '
              "the app's functionality changes. Any update will be reflected in "
              'the "Last updated" date at the top of this page. We encourage you '
              'to review this page occasionally. Continued use of the app after a '
              'change is posted constitutes your acceptance of the revised policy.',
        ],
      ),
      LegalSection(
        heading: '11. Contact Us',
        paragraphs: [
          'If you have any questions about this Privacy Policy or how '
              '${AppConstants.appName} handles information, you can reach us at '
              '${AppConstants.supportEmail}.',
        ],
      ),
    ],
  );

  static const LegalDocument termsOfService = LegalDocument(
    lastUpdated: _lastUpdated,
    intro:
        'These Terms of Service ("Terms") govern your access to and use of '
        '${AppConstants.appName} (the "app"). By downloading, installing, or '
        'using the app, you agree to be bound by these Terms. If you do not '
        'agree, please do not use the app.',
    sections: [
      LegalSection(
        heading: '1. Acceptance of Terms',
        paragraphs: [
          'By downloading or using ${AppConstants.appName}, you confirm that '
              'you accept these Terms and agree to comply with them. If you are '
              'using the app on behalf of a minor, you are responsible for '
              'ensuring their use complies with these Terms.',
        ],
      ),
      LegalSection(
        heading: '2. License to Use the App',
        paragraphs: [
          'We grant you a limited, personal, non-exclusive, non-transferable, '
              'revocable license to install and use ${AppConstants.appName} on '
              'devices you own or control, solely for your own personal, non-'
              'commercial use. This license does not include the right to '
              'sublicense, sell, rent, lease, or otherwise transfer the app to '
              'any third party.',
        ],
      ),
      LegalSection(
        heading: '3. Intellectual Property',
        paragraphs: [
          'The app — including its design, layout, source code, logo, and '
              'branding — is the property of the developer of ${AppConstants.appName} '
              'and is protected by applicable copyright, trademark, and other '
              'intellectual property laws.',
          'Except for the rights expressly granted to you in these Terms, no '
              'other rights are granted, and all rights not expressly granted are '
              'reserved.',
        ],
      ),
      LegalSection(
        heading: '4. Wallpaper Content & Personal Use',
        paragraphs: [
          'Wallpapers included with ${AppConstants.appName} are licensed for '
              'personal use only — including setting them as your home screen or '
              'lock screen background, and sharing individual wallpapers with '
              'others for personal, non-commercial purposes.',
          'You may not resell, sublicense, redistribute in bulk, or use the '
              'wallpapers for any commercial purpose — including incorporating '
              'them into another product or service — without prior written '
              'permission.',
        ],
      ),
      LegalSection(
        heading: '5. Acceptable Use',
        paragraphs: [
          'When using the app, you agree not to:',
          '•  Reverse-engineer, decompile, or disassemble any part of the app, '
              'except where expressly permitted by applicable law.\n'
              '•  Modify, adapt, or create derivative works based on the app '
              'itself.\n'
              '•  Use the app in any way that violates applicable local, '
              'national, or international law.\n'
              "•  Attempt to interfere with the app's normal operation or "
              'circumvent any technical limitation.',
        ],
      ),
      LegalSection(
        heading: '6. Offline Functionality & No Account',
        paragraphs: [
          '${AppConstants.appName} is designed to work entirely offline. It '
              'does not require an account, does not connect to a backend server, '
              'and includes no advertising and no in-app purchases. All '
              'wallpapers are bundled with the app and remain available without '
              'an internet connection.',
        ],
      ),
      LegalSection(
        heading: '7. Disclaimer of Warranties',
        paragraphs: [
          'The app is provided "as is" and "as available," without warranties '
              'of any kind, whether express or implied, including but not limited '
              'to implied warranties of merchantability, fitness for a particular '
              'purpose, and non-infringement. We do not warrant that the app '
              'will be uninterrupted, error-free, or compatible with every '
              'device.',
        ],
      ),
      LegalSection(
        heading: '8. Limitation of Liability',
        paragraphs: [
          'To the maximum extent permitted by applicable law, the developer of '
              '${AppConstants.appName} shall not be liable for any indirect, '
              'incidental, special, consequential, or punitive damages, or any '
              'loss of data, arising out of or related to your use of, or '
              'inability to use, the app.',
        ],
      ),
      LegalSection(
        heading: '9. Termination',
        paragraphs: [
          'We may discontinue, suspend, or modify the app, or your access to '
              'future updates, at our discretion — including if you violate these '
              'Terms. Termination does not affect your right to continue using a '
              'version of the app already installed on your device, though '
              'future updates and support may no longer be available.',
        ],
      ),
      LegalSection(
        heading: '10. Changes to the App and These Terms',
        paragraphs: [
          'We may update the app and these Terms from time to time to reflect '
              'new features, new wallpapers, or legal requirements. Material '
              'changes will be reflected in the "Last updated" date at the top '
              'of this page. Continued use of the app after changes take effect '
              'constitutes your acceptance of the revised Terms.',
        ],
      ),
      LegalSection(
        heading: '11. Governing Law',
        paragraphs: [
          'These Terms are governed by the applicable consumer protection and '
              'technology laws of your country or region of residence, to the '
              'extent such laws apply, without regard to conflict-of-law '
              'principles.',
        ],
      ),
      LegalSection(
        heading: '12. Contact Us',
        paragraphs: [
          'If you have any questions about these Terms, you can reach us at '
              '${AppConstants.supportEmail}.',
        ],
      ),
    ],
  );

  const LegalContent._();
}
