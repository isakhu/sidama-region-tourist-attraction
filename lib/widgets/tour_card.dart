import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/tour.dart';
import '../providers/language_provider.dart';
import '../screens/tour_detail_screen.dart';
import '../theme/app_theme.dart';

/// Tour Card Widget
/// A reusable card component that displays tour information
/// Used in home screen and tours screen

class TourCard extends StatelessWidget {
  final Tour tour;

  const TourCard({
    super.key,
    required this.tour,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = context.watch<LanguageProvider>().currentLanguageCode;

    return Card(
      clipBehavior: Clip.antiAlias, // Clip content to card shape
      child: InkWell(
        // Make the card tappable
        onTap: () {
          // Navigate to tour detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TourDetailScreen(tour: tour),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tour image
            _buildImage(),
            
            // Tour information
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    tour.getTitle(languageCode),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppTheme.sidamaRed,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tour.location,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Price and duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      if (tour.price != null)
                        Text(
                          '${tour.price!.toStringAsFixed(0)} ${l10n.birr}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.sidamaGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Text(
                          l10n.free,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.sidamaGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      
                      // Duration
                      if (tour.duration != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppTheme.mediumGrey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tour.duration!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the tour image with placeholder and error handling
  Widget _buildImage() {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: tour.imageUrl != null
          ? CachedNetworkImage(
              imageUrl: tour.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.lightGrey,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => _buildPlaceholder(),
            )
          : _buildPlaceholder(),
    );
  }

  /// Build placeholder when image is not available
  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sidamaRed.withOpacity(0.7),
            AppTheme.sidamaGreen.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.tour,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }
}
