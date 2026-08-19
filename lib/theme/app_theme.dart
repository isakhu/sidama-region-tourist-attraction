import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Theme Configuration
/// This file defines the visual style of the entire app
/// Colors are inspired by the Sidama flag: Red, White, and Green

class AppTheme {
  // Sidama Flag Colors
  static const Color sidamaRed = Color(0xFFE31E24);      // Primary red
  static const Color sidamaGreen = Color(0xFF00843D);    // Primary green
  static const Color sidamaWhite = Color(0xFFFFFFFF);    // White
  
  // Additional UI colors
  static const Color darkText = Color(0xFF1A1A1A);       // Dark text
  static const Color lightGrey = Color(0xFFF5F5F5);      // Light backgrounds
  static const Color mediumGrey = Color(0xFF9E9E9E);     // Secondary text
  
  /// Light theme configuration
  /// This is the main theme used throughout the app
  static ThemeData get lightTheme {
    return ThemeData(
      // Use Material 3 design system (latest version)
      useMaterial3: true,
      
      // Primary color scheme based on Sidama red
      primaryColor: sidamaRed,
      colorScheme: ColorScheme.light(
        primary: sidamaRed,           // Main brand color
        secondary: sidamaGreen,       // Accent color
        surface: sidamaWhite,         // Card and surface backgrounds
        background: lightGrey,        // Screen backgrounds
        error: Colors.red.shade700,   // Error messages
        onPrimary: sidamaWhite,       // Text on primary color
        onSecondary: sidamaWhite,     // Text on secondary color
        onSurface: darkText,          // Text on surfaces
        onBackground: darkText,       // Text on backgrounds
      ),
      
      // Scaffold (screen) background color
      scaffoldBackgroundColor: lightGrey,
      
      // AppBar styling
      appBarTheme: AppBarTheme(
        backgroundColor: sidamaRed,
        foregroundColor: sidamaWhite,
        elevation: 0, // Flat design, no shadow
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: sidamaWhite,
        ),
      ),
      
      // Text theme - defines all text styles in the app
      textTheme: TextTheme(
        // Large titles
        headlineLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        // Medium titles
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        // Small titles
        headlineSmall: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        // Body text (main content)
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          color: darkText,
        ),
        // Secondary body text
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          color: darkText,
        ),
        // Small text (captions, labels)
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          color: mediumGrey,
        ),
      ),
      
      // Card styling
      cardTheme: CardTheme(
        color: sidamaWhite,
        elevation: 2, // Subtle shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Elevated button styling (primary buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: sidamaRed,
          foregroundColor: sidamaWhite,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined button styling (secondary buttons)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: sidamaGreen,
          side: const BorderSide(color: sidamaGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input field styling
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: sidamaWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: mediumGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: mediumGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: sidamaRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: darkText,
        size: 24,
      ),
    );
  }
}
