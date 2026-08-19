import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/places_provider.dart';
import '../widgets/place_card.dart';
import '../theme/app_theme.dart';
import 'map_view_screen.dart';
import 'place_detail_screen.dart';
import 'settings_screen.dart';

/// Places Home Screen
/// Home screen that displays real data from Supabase 'places' table
/// Features loading states, error handling, and pull-to-refresh

class PlacesHomeScreen extends StatefulWidget {
  const PlacesHomeScreen({super.key});

  @override
  State<PlacesHomeScreen> createState() => _PlacesHomeScreenState();
}

class _PlacesHomeScreenState extends State<PlacesHomeScreen> {
  int _selectedIndex = 0; // Current tab index
  
  @override
  void initState() {
    super.initState();
    // Load places when the screen first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlacesProvider>().fetchPlaces();
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
    final l10n = AppLocalizations.of(context)!;

    // List of screens for each tab
    final screens = [
      _buildHomeContent(context, l10n),
      const MapViewScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      // App bar
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text(l10n.appTitle),
              actions: [
                _buildLanguageSelector(context),
              ],
            )
          : null,
      
      // Main content
      body: screens[_selectedIndex],
      
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppTheme.sidamaRed,
        unselectedItemColor: AppTheme.mediumGrey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  /// Build main content with loading and error states
  Widget _buildHomeContent(BuildContext context, AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: () => context.read<PlacesProvider>().refresh(),
      color: AppTheme.sidamaRed,
      child: _buildContent(context, l10n),
    );
  }

  /// Build main content with loading and error states
  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    return Consumer<PlacesProvider>(
      builder: (context, placesProvider, child) {
        // LOADING STATE
        if (placesProvider.isLoading && !placesProvider.hasPlaces) {
          return _buildLoadingState();
        }

        // ERROR STATE
        if (placesProvider.hasError && !placesProvider.hasPlaces) {
          return _buildErrorState(context, placesProvider, l10n);
        }

        // EMPTY STATE
        if (!placesProvider.hasPlaces) {
          return _buildEmptyState(context, l10n);
        }

        // SUCCESS STATE - Show places
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero section
              _buildHeroSection(context, l10n),
              
              const SizedBox(height: 32),
              
              // Featured places section
              _buildFeaturedPlacesSection(context, placesProvider, l10n),
              
              const SizedBox(height: 32),
              
              // All places grid
              _buildAllPlacesSection(context, placesProvider, l10n),
              
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  /// Loading state with circular progress indicator
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.sidamaRed,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'Loading amazing places...',
            style: TextStyle(
              color: AppTheme.mediumGrey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Error state with retry button
  Widget _buildErrorState(
    BuildContext context,
    PlacesProvider provider,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppTheme.sidamaRed.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              provider.errorMessage ?? 'Failed to load places',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => provider.fetchPlaces(),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state when no places found
  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.place_outlined,
              size: 80,
              color: AppTheme.mediumGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No places found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add some places to your Supabase database to see them here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Premium hero section
  Widget _buildHeroSection(BuildContext context, AppLocalizations l10n) {
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Featured places horizontal scroll section
  Widget _buildFeaturedPlacesSection(
    BuildContext context,
    PlacesProvider provider,
    AppLocalizations l10n,
  ) {
    final featuredPlaces = provider.places.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured Places',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Discover amazing destinations',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGrey,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Horizontal scroll list
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: featuredPlaces.length,
            itemBuilder: (context, index) {
              final place = featuredPlaces[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: PlaceCard(
                  place: place,
                  onTap: () => _showPlaceDetails(context, place),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// All places grid section
  Widget _buildAllPlacesSection(
    BuildContext context,
    PlacesProvider provider,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Places',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${provider.places.length} places to explore',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGrey,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Grid of places
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.places.length,
            itemBuilder: (context, index) {
              final place = provider.places[index];
              return PlaceCard(
                place: place,
                onTap: () => _showPlaceDetails(context, place),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Show place details in a detail screen with smooth transition
  void _showPlaceDetails(BuildContext context, place) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PlaceDetailScreen(place: place),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Smooth slide up transition
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
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
}
