import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/tour_provider.dart';
import '../widgets/tour_card.dart';
import '../widgets/event_card.dart';
import '../theme/app_theme.dart';
import 'tours_screen.dart';
import 'events_screen.dart';

/// Home Screen
/// This is the main landing page users see when they open the app
/// Shows welcome message, popular tours, and upcoming events

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Current tab index

  @override
  void initState() {
    super.initState();
    // Load tours and events when the screen first loads
    // This runs once when the widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TourProvider>().fetchTours();
      context.read<TourProvider>().fetchEvents();
    });
  }

  /// Handle bottom navigation bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get localization strings
    final l10n = AppLocalizations.of(context)!;
    
    // List of screens for each tab
    final screens = [
      _buildHomeContent(context, l10n),
      const ToursScreen(),
      const EventsScreen(),
      _buildProfileContent(context, l10n),
    ];

    return Scaffold(
      // App bar at the top
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          // Language selector button
          _buildLanguageSelector(context),
        ],
      ),
      
      // Main content area
      body: screens[_selectedIndex],
      
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.sidamaRed,
        unselectedItemColor: AppTheme.mediumGrey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: l10n.tours,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.event),
            label: l10n.events,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }

  /// Build the home tab content
  Widget _buildHomeContent(BuildContext context, AppLocalizations l10n) {
    return RefreshIndicator(
      // Pull-to-refresh functionality
      onRefresh: () => context.read<TourProvider>().refreshAll(),
      color: AppTheme.sidamaRed,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with welcome message
            _buildPremiumHeroSection(context, l10n),
            
            const SizedBox(height: 32),
            
            // Featured tours section (horizontal scroll)
            _buildFeaturedToursSection(context, l10n),
            
            const SizedBox(height: 32),
            
            // Upcoming events section (vertical list)
            _buildPremiumEventsSection(context, l10n),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Premium hero section with welcome message and elegant design
  Widget _buildPremiumHeroSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sidamaRed,
            AppTheme.sidamaRed.withOpacity(0.8),
            AppTheme.sidamaGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.sidamaRed.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.welcomeMessage,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.exploreRegion,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // Search hint
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.9),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.search,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Featured tours section with premium horizontal scroll
  Widget _buildFeaturedToursSection(BuildContext context, AppLocalizations l10n) {
    return Consumer<TourProvider>(
      builder: (context, tourProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with premium styling
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Featured Tours',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Handpicked experiences for you',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => _onItemTapped(1),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: Text(l10n.viewAll),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.sidamaRed,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tours horizontal scroll
            if (tourProvider.isLoadingTours)
              const SizedBox(
                height: 320,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (tourProvider.toursError != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(child: Text(tourProvider.toursError!)),
              )
            else if (tourProvider.tours.isEmpty)
              _buildEmptyState(context, l10n.noToursFound, Icons.tour)
            else
              SizedBox(
                height: 320,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: tourProvider.tours.take(5).length,
                  itemBuilder: (context, index) {
                    final tour = tourProvider.tours[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildPremiumTourCard(context, tour, l10n),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  /// Premium events section with vertical list
  Widget _buildPremiumEventsSection(BuildContext context, AppLocalizations l10n) {
    return Consumer<TourProvider>(
      builder: (context, tourProvider, child) {
        final upcomingEvents = tourProvider.upcomingEvents;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.upcomingEvents,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Don\'t miss these amazing events',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => _onItemTapped(2),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: Text(l10n.viewAll),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.sidamaGreen,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Events list
            if (tourProvider.isLoadingEvents)
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (tourProvider.eventsError != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(child: Text(tourProvider.eventsError!)),
              )
            else if (upcomingEvents.isEmpty)
              _buildEmptyState(context, l10n.noEventsFound, Icons.event)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: upcomingEvents.take(3).length,
                itemBuilder: (context, index) {
                  final event = upcomingEvents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildPremiumEventCard(context, event, l10n),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  /// Premium tour card with rounded image and elegant design
  Widget _buildPremiumTourCard(BuildContext context, tour, AppLocalizations l10n) {
    final languageCode = context.watch<LanguageProvider>().currentLanguageCode;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TourDetailScreen(tour: tour),
          ),
        );
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: tour.imageUrl != null
                      ? Image.network(
                          tour.imageUrl!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(180),
                        )
                      : _buildPlaceholderImage(180),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                // Price badge
                if (tour.price != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.sidamaGreen,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.sidamaGreen.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '${tour.price!.toStringAsFixed(0)} ${l10n.birr}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.getTitle(languageCode),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppTheme.sidamaRed.withOpacity(0.8),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tour.location,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mediumGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (tour.duration != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Premium event card with horizontal layout
  Widget _buildPremiumEventCard(BuildContext context, event, AppLocalizations l10n) {
    final languageCode = context.watch<LanguageProvider>().currentLanguageCode;
    
    return GestureDetector(
      onTap: () {
        // Show event details
        EventCard(event: event);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Event image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: event.imageUrl != null
                  ? Image.network(
                      event.imageUrl!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(120, width: 120),
                    )
                  : _buildPlaceholderImage(120, width: 120),
            ),
            // Event details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date badge
                    if (event.eventDate != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: event.isToday 
                              ? AppTheme.sidamaRed.withOpacity(0.1)
                              : AppTheme.sidamaGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event.isToday ? l10n.today : _formatEventDate(event.eventDate!),
                          style: TextStyle(
                            color: event.isToday ? AppTheme.sidamaRed : AppTheme.sidamaGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      event.getTitle(languageCode),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppTheme.mediumGrey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  /// Build placeholder image with gradient
  Widget _buildPlaceholderImage(double height, {double? width}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sidamaRed.withOpacity(0.6),
            AppTheme.sidamaGreen.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image,
          size: height * 0.3,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            icon,
            size: 64,
            color: AppTheme.mediumGrey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.mediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Format event date
  String _formatEventDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference < 7) return 'In $difference days';
    
    return '${date.month}/${date.day}';
  }

  /// Language selector dropdown
  Widget _buildLanguageSelector(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          onSelected: (languageCode) {
            languageProvider.changeLanguage(languageCode);
          },
          itemBuilder: (context) {
            return languageProvider.availableLanguages.map((lang) {
              return PopupMenuItem<String>(
                value: lang['code'],
                child: Text(lang['name']!),
              );
            }).toList();
          },
        );
      },
    );
  }

  /// Profile/Settings content
  Widget _buildProfileContent(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_outline,
              size: 100,
              color: AppTheme.sidamaRed,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.profile,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Profile and settings features coming soon!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
