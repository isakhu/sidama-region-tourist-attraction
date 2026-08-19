import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tour.dart';
import '../models/event.dart';

/// Supabase Service
/// This service handles all communication with Supabase backend
/// Provides methods for authentication, data fetching, and CRUD operations

class SupabaseService {
  // Get the Supabase client instance
  final _supabase = Supabase.instance.client;

  /// Get current user (if authenticated)
  User? get currentUser => _supabase.auth.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // ==================== AUTHENTICATION ====================

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // ==================== TOURS ====================

  /// Fetch all tours
  Future<List<Tour>> fetchTours() async {
    final response = await _supabase
        .from('tours')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Tour.fromJson(json))
        .toList();
  }

  /// Fetch a single tour by ID
  Future<Tour?> fetchTourById(String id) async {
    final response = await _supabase
        .from('tours')
        .select()
        .eq('id', id)
        .single();

    return Tour.fromJson(response);
  }

  /// Search tours by title or location
  Future<List<Tour>> searchTours(String query) async {
    final response = await _supabase
        .from('tours')
        .select()
        .or('title_en.ilike.%$query%,location.ilike.%$query%')
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Tour.fromJson(json))
        .toList();
  }

  // ==================== EVENTS ====================

  /// Fetch all events
  Future<List<Event>> fetchEvents() async {
    final response = await _supabase
        .from('events')
        .select()
        .order('event_date', ascending: true);

    return (response as List)
        .map((json) => Event.fromJson(json))
        .toList();
  }

  /// Fetch upcoming events only
  Future<List<Event>> fetchUpcomingEvents() async {
    final now = DateTime.now().toIso8601String();
    
    final response = await _supabase
        .from('events')
        .select()
        .gte('event_date', now)
        .order('event_date', ascending: true);

    return (response as List)
        .map((json) => Event.fromJson(json))
        .toList();
  }

  /// Fetch a single event by ID
  Future<Event?> fetchEventById(String id) async {
    final response = await _supabase
        .from('events')
        .select()
        .eq('id', id)
        .single();

    return Event.fromJson(response);
  }

  /// Search events by title or location
  Future<List<Event>> searchEvents(String query) async {
    final response = await _supabase
        .from('events')
        .select()
        .or('title_en.ilike.%$query%,location.ilike.%$query%')
        .order('event_date', ascending: true);

    return (response as List)
        .map((json) => Event.fromJson(json))
        .toList();
  }

  // ==================== ADMIN OPERATIONS ====================
  // These would typically require authentication and proper permissions

  /// Create a new tour (admin only)
  Future<Tour> createTour(Tour tour) async {
    final response = await _supabase
        .from('tours')
        .insert(tour.toJson())
        .select()
        .single();

    return Tour.fromJson(response);
  }

  /// Update a tour (admin only)
  Future<Tour> updateTour(Tour tour) async {
    final response = await _supabase
        .from('tours')
        .update(tour.toJson())
        .eq('id', tour.id)
        .select()
        .single();

    return Tour.fromJson(response);
  }

  /// Delete a tour (admin only)
  Future<void> deleteTour(String id) async {
    await _supabase
        .from('tours')
        .delete()
        .eq('id', id);
  }

  /// Create a new event (admin only)
  Future<Event> createEvent(Event event) async {
    final response = await _supabase
        .from('events')
        .insert(event.toJson())
        .select()
        .single();

    return Event.fromJson(response);
  }

  /// Update an event (admin only)
  Future<Event> updateEvent(Event event) async {
    final response = await _supabase
        .from('events')
        .update(event.toJson())
        .eq('id', event.id)
        .select()
        .single();

    return Event.fromJson(response);
  }

  /// Delete an event (admin only)
  Future<void> deleteEvent(String id) async {
    await _supabase
        .from('events')
        .delete()
        .eq('id', id);
  }
}
