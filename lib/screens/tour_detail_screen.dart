import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/tour.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

/// Tour Detail Screen
/// Shows detailed information about a specific tour

class TourDetailScreen extends StatelessWidget {
  final Tour tour;

  const TourDetailScreen({
    super.key,
    required this.tour,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = context.watch<LanguageProvider>().currentLanguageCode;

    return Scaffold(
      // Custom app bar with image background
      body: CustomScrollView(
        slivers: [
          // Collapsible app bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                tour.getTitle(languageCode),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: tour.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: tour.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.lightGrey,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.lightGrey,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.sidamaRed, AppTheme.sidamaGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.tour,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  _buildInfoRow(
                    context,
                    Icons.location_on,
                    l10n.location,
                    tour.location,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Duration
                  if (tour.duration != null)
                    _buildInfoRow(
                      context,
                      Icons.access_time,
                      l10n.duration,
                      tour.duration!,
                    ),
                  
                  if (tour.duration != null) const SizedBox(height: 12),
                  
                  // Price
                  _buildInfoRow(
                    context,
                    Icons.attach_money,
                    l10n.price,
                    tour.price != null
                        ? '${tour.price!.toStringAsFixed(0)} ${l10n.birr}'
                        : l10n.free,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description section
                  Text(
                    l10n.about,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    tour.getDescription(languageCode),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Book now button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement booking functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${l10n.bookNow} - Coming soon!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(l10n.bookNow),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build an info row with icon, label, and value
  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.sidamaRed,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
