import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tour.dart';
import '../models/event.dart';

/// Tour Provider
/// This manages tours and events data from Supabase
/// Handles loading, caching, and state management

class TourProvider extends ChangeNotifier {
  // Get Supabase client instance
  final _supabase = Supabase.instance.client;

  // Lists to store tours and events
  List<Tour> _tours = [];
  List<Event> _events = [];

  // Loading states
  bool _isLoadingTours = false;
  bool _isLoadingEvents = false;

  // Error messages
  String? _toursError;
  String? _eventsError;

  // Getters - allow other parts of the app to access this data
  List<Tour> get tours => _tours;
  List<Event> get events => _events;
  bool get isLoadingTours => _isLoadingTours;
  bool get isLoadingEvents => _isLoadingEvents;
  String? get toursError => _toursError;
  String? get eventsError => _eventsError;

  /// Fetch all tours from Supabase
  /// This is an async function - it waits for data from the server
  Future<void> fetchTours() async {
    // Set loading state to true
    _isLoadingTours = true;
    _toursError = null;
    notifyListeners(); // Update UI to show loading indicator

    try {
      // Query the 'tours' table in Supabase
      // Order by creation date (newest first)
      final response = await _supabase
          .from('tours')
          .select()
          .order('created_at', ascending: false);

      // Convert JSON data to Tour objects
      _tours = (response as List)
          .map((json) => Tour.fromJson(json))
          .toList();

      _toursError = null; // Clear any previous errors
    } catch (e) {
      // If something goes wrong, store the error message
      _toursError = 'Failed to load tours: ${e.toString()}';
      _tours = []; // Clear tours list
    } finally {
      // Always set loading to false when done
      _isLoadingTours = false;
      notifyListeners(); // Update UI with new data or error
    }
  }

  /// Fetch all events from Supabase
  Future<void> fetchEvents() async {
    _isLoadingEvents = true;
    _eventsError = null;
    notifyListeners();

    try {
      // Query the 'events' table in Supabase
      // Order by event date (soonest first)
      final response = await _supabase
          .from('events')
          .select()
          .order('event_date', ascending: true);

      // Convert JSON data to Event objects
      _events = (response as List)
          .map((json) => Event.fromJson(json))
          .toList();

      _eventsError = null;
    } catch (e) {
      _eventsError = 'Failed to load events: ${e.toString()}';
      _events = [];
    } finally {
      _isLoadingEvents = false;
      notifyListeners();
    }
  }

  /// Get upcoming events only (events in the future)
  List<Event> get upcomingEvents {
    return _events.where((event) => event.isUpcoming).toList();
  }

  /// Search tours by title or location
  /// This is useful for implementing a search feature
  List<Tour> searchTours(String query, String languageCode) {
    if (query.isEmpty) return _tours;

    final lowerQuery = query.toLowerCase();
    return _tours.where((tour) {
      final title = tour.getTitle(languageCode).toLowerCase();
      final location = tour.location.toLowerCase();
      return title.contains(lowerQuery) || location.contains(lowerQuery);
    }).toList();
  }

  /// Search events by title or location
  List<Event> searchEvents(String query, String languageCode) {
    if (query.isEmpty) return _events;

    final lowerQuery = query.toLowerCase();
    return _events.where((event) {
      final title = event.getTitle(languageCode).toLowerCase();
      final location = event.location.toLowerCase();
      return title.contains(lowerQuery) || location.contains(lowerQuery);
    }).toList();
  }

  /// Refresh all data (tours and events)
  /// Useful for pull-to-refresh functionality
  Future<void> refreshAll() async {
    await Future.wait([
      fetchTours(),
      fetchEvents(),
    ]);
  }
}
