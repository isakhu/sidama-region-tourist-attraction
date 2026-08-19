/// Place Model
/// This class represents a place from your Supabase 'places' table
/// It contains name, description, image_url, and location coordinates

class Place {
  final String id;                    // Unique identifier
  final String name;                  // Place name
  final String description;           // Place description
  final String? imageUrl;             // Image URL (optional)
  final double? latitude;             // Latitude coordinate (optional)
  final double? longitude;            // Longitude coordinate (optional)
  final DateTime? createdAt;          // When the place was created (optional)

  /// Constructor - creates a new Place object
  Place({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.createdAt,
  });

  /// Factory constructor to create a Place from JSON data
  /// This is used when we receive data from Supabase
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? 'Unnamed Place',
      description: json['description'] as String? ?? 'No description available',
      imageUrl: json['image_url'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convert Place object to JSON
  /// This is used when we send data to Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Check if place has a valid image URL
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  
  /// Check if place has valid coordinates
  bool get hasCoordinates => latitude != null && longitude != null;
}
