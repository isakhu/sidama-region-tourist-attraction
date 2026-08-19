import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/place.dart';

/// Places Service
/// This service handles all communication with the Supabase 'places' table
/// Provides methods for fetching places data with proper error handling

class PlacesService {
  // Get the Supabase client instance
  final _supabase = Supabase.instance.client;

  /// Fetch all places from Supabase
  /// Returns a list of Place objects
  /// Throws an exception if the fetch fails
  Future<List<Place>> fetchPlaces() async {
    try {
      // Query the 'places' table in Supabase
      // Select all columns and order by creation date (newest first)
      final response = await _supabase
          .from('places')
          .select()
          .order('created_at', ascending: false);

      // Convert JSON data to Place objects
      final places = (response as List)
          .map((json) => Place.fromJson(json))
          .toList();

      return places;
    } on PostgrestException catch (e) {
      // Handle Supabase-specific errors
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      // Handle any other errors
      throw Exception('Failed to fetch places: ${e.toString()}');
    }
  }

  /// Fetch a single place by ID
  /// Returns a Place object or null if not found
  Future<Place?> fetchPlaceById(String id) async {
    try {
      final response = await _supabase
          .from('places')
          .select()
          .eq('id', id)
          .single();

      return Place.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // No rows returned
        return null;
      }
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch place: ${e.toString()}');
    }
  }

  /// Search places by name or description
  /// Returns a list of matching Place objects
  Future<List<Place>> searchPlaces(String query) async {
    try {
      if (query.isEmpty) {
        return await fetchPlaces();
      }

      // Search in both name and description columns
      final response = await _supabase
          .from('places')
          .select()
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Place.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to search places: ${e.toString()}');
    }
  }

  /// Fetch places with a limit
  /// Useful for pagination or showing only top N places
  Future<List<Place>> fetchPlacesWithLimit(int limit) async {
    try {
      final response = await _supabase
          .from('places')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => Place.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch places: ${e.toString()}');
    }
  }

  // ==================== ADMIN OPERATIONS ====================
  // These would typically require authentication and proper permissions

  /// Create a new place (admin only)
  Future<Place> createPlace(Place place) async {
    try {
      final response = await _supabase
          .from('places')
          .insert(place.toJson())
          .select()
          .single();

      return Place.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create place: ${e.toString()}');
    }
  }

  /// Update a place (admin only)
  Future<Place> updatePlace(Place place) async {
    try {
      final response = await _supabase
          .from('places')
          .update(place.toJson())
          .eq('id', place.id)
          .select()
          .single();

      return Place.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update place: ${e.toString()}');
    }
  }

  /// Delete a place (admin only)
  Future<void> deletePlace(String id) async {
    try {
      await _supabase
          .from('places')
          .delete()
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete place: ${e.toString()}');
    }
  }
}
