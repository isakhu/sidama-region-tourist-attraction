# Hawassa-Sidama Tour & Event App 🌍

A beautiful Flutter mobile application for discovering tours and events in the Hawassa-Sidama region, featuring multilingual support (Sidaamu Afoo, Amharic, English) and a modern UI inspired by the Sidama flag colors.

## Features ✨

- **Multilingual Support**: Sidaamu Afoo, Amharic, and English
- **Tour Discovery**: Browse and search local tours
- **Event Management**: View upcoming events and activities
- **User Authentication**: Secure login with Supabase
- **Beautiful UI**: Clean design with Sidama flag colors (Red, White, Green)
- **Offline Support**: Cached data for better performance

## Color Palette 🎨

- **Red**: `#E31E24` - Primary accent
- **White**: `#FFFFFF` - Background and text
- **Green**: `#00843D` - Secondary accent
- **Dark**: `#1A1A1A` - Text and UI elements

## Prerequisites 📋

1. **Flutter SDK** (3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   
2. **Supabase Account**
   - Sign up at: https://supabase.com
   - Create a new project
   - Get your project URL and anon key

## Setup Instructions 🚀

### 1. Install Flutter
Follow the official guide for your operating system:
- Windows: https://flutter.dev/docs/get-started/install/windows
- macOS: https://flutter.dev/docs/get-started/install/macos
- Linux: https://flutter.dev/docs/get-started/install/linux

### 2. Clone and Setup Project
```bash
# Navigate to your project directory
cd hawassa_sidama_tour

# Install dependencies
flutter pub get

# Check if Flutter is properly installed
flutter doctor
```

### 3. Configure Supabase

1. Create a file `lib/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

2. Replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY` with your actual Supabase credentials

### 4. Setup Supabase Database

Run these SQL commands in your Supabase SQL editor:

```sql
-- Tours table
CREATE TABLE tours (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title_en TEXT NOT NULL,
  title_am TEXT,
  title_si TEXT,
  description_en TEXT,
  description_am TEXT,
  description_si TEXT,
  location TEXT NOT NULL,
  price DECIMAL(10,2),
  image_url TEXT,
  duration TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Events table
CREATE TABLE events (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title_en TEXT NOT NULL,
  title_am TEXT,
  title_si TEXT,
  description_en TEXT,
  description_am TEXT,
  description_si TEXT,
  location TEXT NOT NULL,
  event_date TIMESTAMP WITH TIME ZONE,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE tours ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- Allow public read access
CREATE POLICY "Public tours are viewable by everyone"
  ON tours FOR SELECT
  USING (true);

CREATE POLICY "Public events are viewable by everyone"
  ON events FOR SELECT
  USING (true);
```

### 5. Run the App
```bash
# Run on connected device or emulator
flutter run

# Build for release
flutter build apk  # For Android
flutter build ios  # For iOS (requires macOS)
```

## Project Structure 📁

```
lib/
├── main.dart                 # App entry point
├── config/
│   └── supabase_config.dart # Supabase configuration
├── models/                   # Data models
│   ├── tour.dart
│   └── event.dart
├── providers/                # State management
│   ├── language_provider.dart
│   └── tour_provider.dart
├── screens/                  # App screens
│   ├── home_screen.dart
│   ├── tours_screen.dart
│   ├── events_screen.dart
│   └── tour_detail_screen.dart
├── widgets/                  # Reusable components
│   ├── tour_card.dart
│   └── event_card.dart
├── services/                 # Backend services
│   └── supabase_service.dart
├── l10n/                     # Localization files
│   ├── app_en.arb
│   ├── app_am.arb
│   └── app_si.arb
└── theme/                    # App theme
    └── app_theme.dart
```

## Learning Resources 📚

- **Flutter Documentation**: https://flutter.dev/docs
- **Supabase Documentation**: https://supabase.com/docs
- **Dart Language Tour**: https://dart.dev/guides/language/language-tour
- **Flutter Widget Catalog**: https://flutter.dev/docs/development/ui/widgets

## Troubleshooting 🔧

**Issue**: "Flutter command not found"
- **Solution**: Make sure Flutter is added to your PATH environment variable

**Issue**: "Supabase connection error"
- **Solution**: Check your internet connection and verify Supabase credentials

**Issue**: "Build failed"
- **Solution**: Run `flutter clean` then `flutter pub get`

## Contributing 🤝

This is a learning project! Feel free to:
- Add new features
- Improve the UI
- Fix bugs
- Add more translations

## License 📄

This project is created for educational purposes.

---

**Happy Coding! 🎉**

For questions or help, refer to the inline code comments - every file is well-documented to help you learn!
