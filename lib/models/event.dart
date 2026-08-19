/// Event Model
/// This class represents an event in our app
/// Similar to Tour, but includes event-specific fields like event date

class Event {
  final String id;                    // Unique identifier
  final String titleEn;               // Title in English
  final String? titleAm;              // Title in Amharic (optional)
  final String? titleSi;              // Title in Sidaamu Afoo (optional)
  final String descriptionEn;         // Description in English
  final String? descriptionAm;        // Description in Amharic (optional)
  final String? descriptionSi;        // Description in Sidaamu Afoo (optional)
  final String location;              // Event location
  final DateTime? eventDate;          // When the event happens
  final String? imageUrl;             // Image URL (optional)
  final DateTime createdAt;           // When the event was created

  /// Constructor - creates a new Event object
  Event({
    required this.id,
    required this.titleEn,
    this.titleAm,
    this.titleSi,
    required this.descriptionEn,
    this.descriptionAm,
    this.descriptionSi,
    required this.location,
    this.eventDate,
    this.imageUrl,
    required this.createdAt,
  });

  /// Factory constructor to create an Event from JSON data
  /// This is used when we receive data from Supabase
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      titleEn: json['title_en'] as String,
      titleAm: json['title_am'] as String?,
      titleSi: json['title_si'] as String?,
      descriptionEn: json['description_en'] as String,
      descriptionAm: json['description_am'] as String?,
      descriptionSi: json['description_si'] as String?,
      location: json['location'] as String,
      eventDate: json['event_date'] != null 
          ? DateTime.parse(json['event_date'] as String)
          : null,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert Event object to JSON
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
      'event_date': eventDate?.toIso8601String(),
      'image_url': imageUrl,
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

  /// Check if the event is upcoming (in the future)
  bool get isUpcoming {
    if (eventDate == null) return false;
    return eventDate!.isAfter(DateTime.now());
  }

  /// Check if the event is happening today
  bool get isToday {
    if (eventDate == null) return false;
    final now = DateTime.now();
    return eventDate!.year == now.year &&
           eventDate!.month == now.month &&
           eventDate!.day == now.day;
  }
}
