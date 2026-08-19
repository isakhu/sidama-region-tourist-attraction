# 🤖 PROMPT FOR ANDROID STUDIO (NATIVE ANDROID)

Copy and paste this to an AI assistant to rebuild your app in **Kotlin/Java for Android Studio**:

---

## 📋 THE PROMPT:

```
I need to convert my Flutter app to a native Android app using Android Studio with Kotlin.

Here's what my app does:

1. **Home Screen:**
   - Shows a list of places from Supabase database
   - Each place has: name, description, image, latitude, longitude
   - Cards with images in a scrollable list
   - Pull-to-refresh functionality
   - Loading and error states

2. **Map View:**
   - Google Maps showing all places as markers
   - Tap marker to see place details
   - Bottom sheet preview
   - Navigate to detail screen

3. **Place Detail Screen:**
   - Full-screen image header
   - Place name and description
   - Small embedded Google Map showing location
   - Coordinates display
   - Smooth slide-up animation

4. **Settings Screen:**
   - Language switcher (English, Amharic, Sidaamu Afoo)
   - App information
   - About and contact sections

5. **Features:**
   - Multilingual support (3 languages)
   - Supabase backend integration
   - Google Maps integration
   - Bottom navigation (Home, Map, Settings)
   - Material Design with custom colors:
     - Primary: #E31E24 (Sidama Red)
     - Secondary: #00843D (Sidama Green)
   - Smooth animations and transitions

6. **Database Structure (Supabase):**
   ```sql
   CREATE TABLE places (
     id UUID PRIMARY KEY,
     name TEXT NOT NULL,
     description TEXT NOT NULL,
     image_url TEXT,
     latitude DECIMAL(10, 8),
     longitude DECIMAL(11, 8),
     created_at TIMESTAMP
   );
   ```

Please create a complete Android Studio project with:
- Kotlin code
- XML layouts
- Retrofit for Supabase API calls
- Google Maps integration
- ViewBinding
- MVVM architecture
- Material Design 3
- String resources for 3 languages
- Gradle dependencies
- Step-by-step setup instructions

Make it beginner-friendly with comments explaining each part.
```

---

## 🎯 WHAT YOU'LL GET:

A complete **native Android app** that:
- ✅ Works in Android Studio directly
- ✅ No Flutter needed
- ✅ Uses Kotlin (easier than Flutter for beginners)
- ✅ Same features as your Flutter app
- ✅ Easier to run and debug

---

## 📱 ALTERNATIVE: Use This Prompt for React Native

```
Convert the above Flutter app to React Native with:
- TypeScript
- React Navigation
- Supabase JS client
- React Native Maps
- i18n for translations
- Styled components
- Complete setup guide
```

---

## 🌐 ALTERNATIVE: Use This Prompt for Web App

```
Convert the above Flutter app to a web app using:
- React + TypeScript
- Supabase JS client
- Google Maps JavaScript API
- i18next for translations
- Tailwind CSS with Sidama colors
- Responsive design
- Complete deployment guide
```

---

**Choose your platform and paste the prompt to any AI assistant!** 🚀
