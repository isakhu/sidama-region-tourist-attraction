import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/event.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

/// Event Card Widget
/// A reusable card component that displays event information
/// Used in home screen and events screen

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = context.watch<LanguageProvider>().currentLanguageCode;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Show event details in a bottom sheet
          _showEventDetails(context, l10n, languageCode);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image
            _buildImage(),
            
            // Event information
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event.getTitle(languageCode),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                            event.location,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Date
                    if (event.eventDate != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppTheme.sidamaGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(event.eventDate!, l10n),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.sidamaGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    
                    // "Today" badge
                    if (event.isToday)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.sidamaRed,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          l10n.today,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the event image
  Widget _buildImage() {
    return SizedBox(
      width: 120,
      height: 120,
      child: event.imageUrl != null
          ? CachedNetworkImage(
              imageUrl: event.imageUrl!,
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
          Icons.event,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(date.year, date.month, date.day);
    
    // Check if event is today
    if (eventDay == today) {
      return l10n.today;
    }
    
    // Check if event is tomorrow
    final tomorrow = today.add(const Duration(days: 1));
    if (eventDay == tomorrow) {
      return l10n.tomorrow;
    }
    
    // Format as date
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Show event details in a bottom sheet
  void _showEventDetails(
    BuildContext context,
    AppLocalizations l10n,
    String languageCode,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.mediumGrey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Title
                    Text(
                      event.getTitle(languageCode),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppTheme.sidamaRed,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.location,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Date
                    if (event.eventDate != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppTheme.sidamaGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('EEEE, MMMM dd, yyyy - hh:mm a')
                                .format(event.eventDate!),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Description
                    Text(
                      l10n.about,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      event.getDescription(languageCode),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Learn more button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${l10n.learnMore} - Coming soon!'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(l10n.learnMore),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
