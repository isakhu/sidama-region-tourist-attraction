# Google Maps Setup Guide

This guide will help you set up Google Maps in your Flutter app.

## Step 1: Get Google Maps API Key

### For Android

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable **Maps SDK for Android**:
   - Go to "APIs & Services" > "Library"
   - Search for "Maps SDK for Android"
   - Click "Enable"

4. Create API Key:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "API Key"
   - Copy your API key

5. (Optional) Restrict your API key:
   - Click on your API key
   - Under "Application restrictions", select "Android apps"
   - Add your package name and SHA-1 certificate fingerprint

### For iOS

1. In the same Google Cloud Console project
2. Enable **Maps SDK for iOS**:
   - Go to "APIs & Services" > "Library"
   - Search for "Maps SDK for iOS"
   - Click "Enable"

3. Use the same API key or create a new one
4. (Optional) Restrict to iOS apps

## Step 2: Configure Android

1. Open `android/app/src/main/AndroidManifest.xml`

2. Add your API key inside the `<application>` tag:

```xml
<manifest ...>
    <application ...>
        <!-- Add this meta-data tag -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_ANDROID_API_KEY_HERE"/>
        
        <activity ...>
            ...
        </activity>
    </application>
</manifest>
```

3. Add permissions before `<application>` tag:

```xml
<manifest ...>
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application ...>
        ...
    </application>
</manifest>
```

4. Update `android/app/build.gradle`:

```gradle
android {
    ...
    defaultConfig {
        ...
        minSdkVersion 21  // Make sure this is at least 21
    }
}
```

## Step 3: Configure iOS

1. Open `ios/Runner/AppDelegate.swift`

2. Add this import at the top:

```swift
import GoogleMaps
```

3. Add this inside the `application` function:

```swift
override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    GMSServices.provideAPIKey("YOUR_IOS_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

4. Add location permissions to `ios/Runner/Info.plist`:

```xml
<dict>
    ...
    <!-- Add these keys -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs access to location to show places on the map.</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>This app needs access to location to show places on the map.</string>
    ...
</dict>
```

5. Update `ios/Podfile`:

```ruby
platform :ios, '12.0'  # Make sure this is at least 12.0
```

## Step 4: Update Supabase Database

Add latitude and longitude columns to your places table:

```sql
-- Add coordinate columns
ALTER TABLE places ADD COLUMN latitude DECIMAL(10, 8);
ALTER TABLE places ADD COLUMN longitude DECIMAL(11, 8);

-- Update existing places with coordinates (Hawassa region examples)
UPDATE places SET latitude = 7.0621, longitude = 38.4776 WHERE name = 'Lake Hawassa';
UPDATE places SET latitude = 6.8500, longitude = 38.5000 WHERE name = 'Sidama Coffee Farms';
UPDATE places SET latitude = 7.0500, longitude = 38.4800 WHERE name = 'Hawassa Fish Market';

-- For new places, include coordinates:
INSERT INTO places (name, description, image_url, latitude, longitude) VALUES
('Wondo Genet Hot Springs', 'Natural hot springs in lush forest', 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800', 7.0500, 38.6167),
('Fichee Festival Ground', 'Cultural celebration venue', 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800', 6.9000, 38.5000);
```

## Step 5: Install Dependencies

Run these commands:

```bash
flutter pub get
cd ios && pod install && cd ..  # For iOS only
```

## Step 6: Test the App

```bash
flutter run
```

## Features Included

### Map View Tab
- ✅ Interactive Google Map showing all places
- ✅ Custom markers for each location
- ✅ Tap markers to see place preview
- ✅ Auto-zoom to fit all markers
- ✅ Info card showing number of locations

### Place Detail Screen
- ✅ Full-screen image header
- ✅ Smooth slide-up transition animation
- ✅ Embedded small map showing exact location
- ✅ Coordinates display
- ✅ Additional place information cards
- ✅ Fade and slide animations

### Navigation
- ✅ Smooth PageRouteBuilder transitions
- ✅ 400ms slide-up animation with easeInOutCubic curve
- ✅ Bottom sheet preview on map
- ✅ Direct navigation to detail screen

## Hawassa Region Coordinates Reference

Use these coordinates for places in the Hawassa-Sidama region:

```
Lake Hawassa: 7.0621, 38.4776
Hawassa City Center: 7.0621, 38.4776
Sidama Region: 6.8500, 38.5000
Wondo Genet: 7.0500, 38.6167
Yirgalem: 6.7500, 38.4167
Aleta Wondo: 6.6000, 38.4333
```

## Troubleshooting

### "MissingPluginException"
- Run `flutter clean`
- Run `flutter pub get`
- Restart your IDE
- For iOS: `cd ios && pod install && cd ..`

### Map shows blank/grey
- Check API key is correct
- Verify Maps SDK is enabled in Google Cloud Console
- Check internet connection
- For Android: Verify API key in AndroidManifest.xml
- For iOS: Verify API key in AppDelegate.swift

### "API key not found"
- Make sure you added the API key to AndroidManifest.xml (Android)
- Make sure you added the API key to AppDelegate.swift (iOS)
- Rebuild the app after adding keys

### Location permission denied
- Check permissions are added to AndroidManifest.xml
- Check permissions are added to Info.plist
- Grant location permission when app asks

### iOS build fails
- Make sure `platform :ios` is at least '12.0' in Podfile
- Run `cd ios && pod install && cd ..`
- Clean build: `flutter clean`

## Testing Without Real Coordinates

If you don't have real coordinates yet, use these test values:

```sql
-- Default to Hawassa city center
UPDATE places SET latitude = 7.0621, longitude = 38.4776 WHERE latitude IS NULL;
```

## API Key Security

⚠️ **Important Security Notes:**

1. **Never commit API keys to public repositories**
2. **Use API key restrictions** in Google Cloud Console
3. **For production**, use environment variables:

```dart
// lib/config/maps_config.dart
class MapsConfig {
  static const String androidApiKey = String.fromEnvironment('MAPS_ANDROID_KEY');
  static const String iosApiKey = String.fromEnvironment('MAPS_IOS_KEY');
}
```

4. **Add to .gitignore**:
```
# API Keys
android/app/src/main/AndroidManifest.xml
ios/Runner/AppDelegate.swift
```

## Cost Considerations

Google Maps has a free tier:
- **$200 free credit per month**
- **28,000 map loads per month** (free)
- **40,000 directions requests per month** (free)

For a small app, you'll likely stay within the free tier.

## Next Steps

1. ✅ Add more places with real coordinates
2. ✅ Add directions functionality
3. ✅ Add place search on map
4. ✅ Add clustering for many markers
5. ✅ Add custom marker icons
6. ✅ Add route planning

---

**Happy Mapping! 🗺️**
