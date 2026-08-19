import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/tour_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/event_card.dart';

/// Events Screen
/// Displays all events with search functionality

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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
                hintText: l10n.searchEvents,
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

          // Events list
          Expanded(
            child: Consumer<TourProvider>(
              builder: (context, tourProvider, child) {
                // Get filtered events based on search query
                final events = _searchQuery.isEmpty
                    ? tourProvider.events
                    : tourProvider.searchEvents(_searchQuery, languageCode);

                // Show loading indicator
                if (tourProvider.isLoadingEvents) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Show error message
                if (tourProvider.eventsError != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tourProvider.eventsError!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => tourProvider.fetchEvents(),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  );
                }

                // Show empty state
                if (events.isEmpty) {
                  return Center(
                    child: Text(l10n.noEventsFound),
                  );
                }

                // Show events in a list
                return RefreshIndicator(
                  onRefresh: () => tourProvider.fetchEvents(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EventCard(event: events[index]),
                      );
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
