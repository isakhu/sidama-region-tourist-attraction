import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Import our custom files
import 'config/supabase_config.dart';
import 'providers/language_provider.dart';
import 'providers/tour_provider.dart';
import 'providers/places_provider.dart';
import 'screens/places_home_screen.dart';
import 'theme/app_theme.dart';

/// Main entry point of the application
/// This is where the app starts running
void main() async {
  // Ensure Flutter is initialized before running async code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with our configuration
  // This connects our app to the backend database
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  // Run the app
  runApp(const HawassaSidamaTourApp());
}

/// Root widget of the application
/// This sets up providers, theme, and localization
class HawassaSidamaTourApp extends StatelessWidget {
  const HawassaSidamaTourApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider allows us to use multiple state management providers
    // Think of providers as a way to share data across the entire app
    return MultiProvider(
      providers: [
        // LanguageProvider manages the current language selection
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        
        // TourProvider manages tours and events data
        ChangeNotifierProvider(create: (_) => TourProvider()),
        
        // PlacesProvider manages places data from Supabase
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
      ],
      child: Consumer<LanguageProvider>(
        // Consumer rebuilds the widget when LanguageProvider changes
        builder: (context, languageProvider, child) {
          return MaterialApp(
            // App title
            title: 'Hawassa-Sidama Tour',
            
            // Remove debug banner in top-right corner
            debugShowCheckedModeBanner: false,
            
            // Apply our custom theme with Sidama flag colors
            theme: AppTheme.lightTheme,
            
            // Localization setup - enables multiple languages
            localizationsDelegates: const [
              AppLocalizations.delegate, // Our custom translations
              GlobalMaterialLocalizations.delegate, // Material widgets translations
              GlobalWidgetsLocalizations.delegate, // General widgets translations
              GlobalCupertinoLocalizations.delegate, // iOS-style widgets translations
            ],
            
            // Supported languages: English, Amharic, Sidaamu Afoo
            supportedLocales: const [
              Locale('en'), // English
              Locale('am'), // Amharic
              Locale('si'), // Sidaamu Afoo
            ],
            
            // Current language from provider
            locale: languageProvider.currentLocale,
            
            // Home screen is the first screen users see
            // Using PlacesHomeScreen to display real Supabase data
            home: const PlacesHomeScreen(),
          );
        },
      ),
    );
  }
}
