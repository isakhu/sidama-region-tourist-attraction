import 'package:flutter/material.dart';
import '../models/place.dart';
import '../services/places_service.dart';

/// Places Provider
/// This manages places data from Supabase
/// Handles loading, caching, error states, and notifies UI of changes

class PlacesProvider extends ChangeNotifier {
  // Service instance for API calls
  final PlacesService _placesService = PlacesService();

  // List to store places
  List<Place> _places = [];

  // Loading state
  bool _isLoading = false;

  // Error message
  String? _errorMessage;

  // Getters - allow other parts of the app to access this data
  List<Place> get places => _places;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasPlaces => _places.isNotEmpty;

  /// Fetch all places from Supabase
  /// This is an async function - it waits for data from the server
  Future<void> fetchPlaces() async {
    // Set loading state to true
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Update UI to show loading indicator

    try {
      // Fetch places from Supabase
      _places = await _placesService.fetchPlaces();
      _errorMessage = null; // Clear any previous errors
      
      debugPrint('✅ Successfully fetched ${_places.length} places');
    } catch (e) {
      // If something goes wrong, store the error message
      _errorMessage = e.toString();
      _places = []; // Clear places list on error
      
      debugPrint('❌ Error fetching places: $_errorMessage');
    } finally {
      // Always set loading to false when done
      _isLoading = false;
      notifyListeners(); // Update UI with new data or error
    }
  }

  /// Fetch limited number of places (for featured section)
  Future<void> fetchFeaturedPlaces({int limit = 5}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _places = await _placesService.fetchPlacesWithLimit(limit);
      _errorMessage = null;
      
      debugPrint('✅ Successfully fetched ${_places.length} featured places');
    } catch (e) {
      _errorMessage = e.toString();
      _places = [];
      
      debugPrint('❌ Error fetching featured places: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search places by query
  Future<void> searchPlaces(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _places = await _placesService.searchPlaces(query);
      _errorMessage = null;
      
      debugPrint('✅ Search returned ${_places.length} places');
    } catch (e) {
      _errorMessage = e.toString();
      _places = [];
      
      debugPrint('❌ Error searching places: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh places data
  /// Useful for pull-to-refresh functionality
  Future<void> refresh() async {
    await fetchPlaces();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get a specific place by ID
  Place? getPlaceById(String id) {
    try {
      return _places.firstWhere((place) => place.id == id);
    } catch (e) {
      return null;
    }
  }
}
