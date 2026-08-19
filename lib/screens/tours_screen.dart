import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/tour_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/tour_card.dart';

/// Tours Screen
/// Displays all available tours with search functionality

class ToursScreen extends StatefulWidget {
  const ToursScreen({super.key});

  @override
  State<ToursScreen> createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  // Text controller for search input
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = context.watch<LanguageProvider>().currentLanguageCode;

    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchTours,
                prefixIcon: const Icon(Icons.search),
                // Clear button
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Tours list
          Expanded(
            child: Consumer<TourProvider>(
              builder: (context, tourProvider, child) {
                // Get filtered tours based on search query
                final tours = _searchQuery.isEmpty
                    ? tourProvider.tours
                    : tourProvider.searchTours(_searchQuery, languageCode);

                // Show loading indicator
                if (tourProvider.isLoadingTours) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Show error message
                if (tourProvider.toursError != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tourProvider.toursError!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => tourProvider.fetchTours(),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  );
                }

                // Show empty state
                if (tours.isEmpty) {
                  return Center(
                    child: Text(l10n.noToursFound),
                  );
                }

                // Show tours in a grid
                return RefreshIndicator(
                  onRefresh: () => tourProvider.fetchTours(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // One column on mobile
                      childAspectRatio: 1.2, // Card width/height ratio
                      mainAxisSpacing: 16,
                    ),
                    itemCount: tours.length,
                    itemBuilder: (context, index) {
                      return TourCard(tour: tours[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
