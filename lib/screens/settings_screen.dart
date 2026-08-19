import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

/// Settings Screen
/// Allows users to change app settings including language preferences
/// Features a clean, organized UI with sections

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Header section
          _buildHeader(context, l10n),
          
          const SizedBox(height: 8),
          
          // Language section
          _buildLanguageSection(context, l10n),
          
          const SizedBox(height: 8),
          
          // App info section
          _buildAppInfoSection(context, l10n),
          
          const SizedBox(height: 8),
          
          // About section
          _buildAboutSection(context, l10n),
        ],
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sidamaRed.withOpacity(0.1),
            AppTheme.sidamaGreen.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.sidamaRed.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.settings,
              size: 48,
              color: AppTheme.sidamaRed,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settings,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your experience',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  /// Build language section
  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.mediumGrey,
              ),
            ),
          ),
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Column(
                children: languageProvider.availableLanguages.map((lang) {
                  final isSelected = languageProvider.currentLanguageCode == lang['code'];
                  return _buildLanguageTile(
                    context,
                    lang['code']!,
                    lang['name']!,
                    isSelected,
                    languageProvider,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build individual language tile
  Widget _buildLanguageTile(
    BuildContext context,
    String code,
    String name,
    bool isSelected,
    LanguageProvider provider,
  ) {
    return InkWell(
      onTap: () {
        provider.changeLanguage(code);
        // Show confirmation snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to $name'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.sidamaGreen,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.lightGrey,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Language icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.sidamaRed.withOpacity(0.1)
                    : AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.language,
                color: isSelected ? AppTheme.sidamaRed : AppTheme.mediumGrey,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Language name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.sidamaRed : AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getLanguageNativeName(code),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Selected indicator
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.sidamaRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Get language native name
  String _getLanguageNativeName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'am':
        return 'አማርኛ';
      case 'si':
        return 'Sidaamu Afoo';
      default:
        return '';
    }
  }

  /// Build app info section
  Widget _buildAppInfoSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Text(
              'App Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.mediumGrey,
              ),
            ),
          ),
          _buildInfoTile(
            context,
            Icons.info_outline,
            'Version',
            '1.0.0',
            null,
          ),
          _buildInfoTile(
            context,
            Icons.phone_android,
            'Platform',
            'Flutter',
            null,
          ),
        ],
      ),
    );
  }

  /// Build about section
  Widget _buildAboutSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Text(
              l10n.about,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.mediumGrey,
              ),
            ),
          ),
          _buildInfoTile(
            context,
            Icons.description,
            'About App',
            'Learn more about Hawassa-Sidama Tour',
            () {
              _showAboutDialog(context, l10n);
            },
          ),
          _buildInfoTile(
            context,
            Icons.contact_mail,
            l10n.contact,
            'Get in touch with us',
            () {
              _showContactDialog(context, l10n);
            },
          ),
          _buildInfoTile(
            context,
            Icons.privacy_tip,
            'Privacy Policy',
            'Read our privacy policy',
            () {
              // TODO: Implement privacy policy
            },
          ),
        ],
      ),
    );
  }

  /// Build info tile
  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.lightGrey,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.mediumGrey,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: AppTheme.mediumGrey,
              ),
          ],
        ),
      ),
    );
  }

  /// Show about dialog
  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.about),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hawassa-Sidama Tour & Event App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Discover the beautiful Sidama region with guided tours and exciting events. '
              'Experience the rich culture, stunning landscapes, and warm hospitality of Hawassa-Sidama.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: AppTheme.mediumGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show contact dialog
  void _showContactDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.contact),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactItem(Icons.email, 'Email', 'info@hawassa-tour.com'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.phone, 'Phone', '+251 46 XXX XXXX'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.location_on, 'Address', 'Hawassa, Ethiopia'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Build contact item
  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.sidamaRed),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.mediumGrey,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
