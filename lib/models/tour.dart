/// Tour Model
/// This class represents a tour in our app
/// It contains all the information about a tour (title, description, price, etc.)

class Tour {
  final String id;                    // Unique identifier
  final String titleEn;               // Title in English
  final String? titleAm;              // Title in Amharic (optional)
  final String? titleSi;              // Title in Sidaamu Afoo (optional)
  final String descriptionEn;         // Description in English
  final String? descriptionAm;        // Description in Amharic (optional)
  final String? descriptionSi;        // Description in Sidaamu Afoo (optional)
  final String location;              // Tour location
  final double? price;                // Tour price (optional)
  final String? imageUrl;             // Image URL (optional)
  final String? duration;             // Tour duration (e.g., "3 hours")
  final DateTime createdAt;           // When the tour was created

  /// Constructor - creates a new Tour object
  Tour({
    required this.id,
    required this.titleEn,
    this.titleAm,
    this.titleSi,
    required this.descriptionEn,
    this.descriptionAm,
    this.descriptionSi,
    required this.location,
    this.price,
    this.imageUrl,
    this.duration,
    required this.createdAt,
  });

  /// Factory constructor to create a Tour from JSON data
  /// This is used when we receive data from Supabase
  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'] as String,
      titleEn: json['title_en'] as String,
      titleAm: json['title_am'] as String?,
      titleSi: json['title_si'] as String?,
      descriptionEn: json['description_en'] as String,
      descriptionAm: json['description_am'] as String?,
      descriptionSi: json['description_si'] as String?,
      location: json['location'] as String,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      imageUrl: json['image_url'] as String?,
      duration: json['duration'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert Tour object to JSON
  /// This is used when we send data to Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_en': titleEn,
      'title_am': titleAm,
      'title_si': titleSi,
      'description_en': descriptionEn,
      'description_am': descriptionAm,
      'description_si': descriptionSi,
      'location': location,
      'price': price,
      'image_url': imageUrl,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get title in the specified language
  /// Falls back to English if translation is not available
  String getTitle(String languageCode) {
    switch (languageCode) {
      case 'am':
        return titleAm ?? titleEn;
      case 'si':
        return titleSi ?? titleEn;
      default:
        return titleEn;
    }
  }

  /// Get description in the specified language
  /// Falls back to English if translation is not available
  String getDescription(String languageCode) {
    switch (languageCode) {
      case 'am':
        return descriptionAm ?? descriptionEn;
      case 'si':
        return descriptionSi ?? descriptionEn;
      default:
        return descriptionEn;
    }
  }
}
