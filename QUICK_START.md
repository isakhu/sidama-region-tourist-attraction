# Quick Start Guide - Supabase Integration

Your app is now connected to Supabase! Here's what you need to do:

## 🚀 Quick Setup (5 minutes)

### 1. Add Your Supabase Credentials

Open `lib/config/supabase_config.dart` and add your credentials:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
}
```

### 2. Create the Database Table

Go to Supabase SQL Editor and run:

```sql
CREATE TABLE places (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE places ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public places are viewable by everyone"
  ON places FOR SELECT
  USING (true);

-- Add sample data
INSERT INTO places (name, description, image_url) VALUES
('Lake Hawassa', 'Beautiful freshwater lake with stunning sunsets', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'),
('Sidama Coffee Farms', 'Experience the birthplace of coffee', 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=800'),
('Hawassa Fish Market', 'Vibrant local market with fresh fish', 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800');
```

### 3. Run the App

```bash
flutter pub get
flutter run
```

## ✨ What You Get

### Loading State
- Shows a circular progress indicator while fetching data
- Displays "Loading amazing places..." message

### Success State
- **Hero Section**: Beautiful gradient header with Sidama colors
- **Featured Places**: Horizontal scrolling cards (top 5 places)
- **All Places**: Grid view of all places from your database

### Error State
- Shows error icon and message
- Displays "Retry" button to fetch data again
- Gracefully handles network errors

### Empty State
- Shows when no places are found
- Helpful message to add places to database

## 📱 Features

✅ **Pull-to-Refresh**: Swipe down to reload data
✅ **Image Caching**: Fast loading with cached images
✅ **Placeholder Images**: Beautiful gradients when images fail
✅ **Error Handling**: Proper error messages with retry option
✅ **Loading States**: Smooth loading indicators
✅ **Responsive Design**: Works on all screen sizes

## 🎨 UI Components

### PlaceCard
- Rounded corners (20px)
- Soft shadows
- Gradient overlay on images
- Truncated text with ellipsis
- Tap to view details

### Loading Indicator
- Sidama red color
- Centered with message
- Smooth animation

### Error Display
- Red error icon
- Clear error message
- Retry button

## 📊 Data Flow

```
App Start
    ↓
PlacesProvider.fetchPlaces()
    ↓
PlacesService.fetchPlaces()
    ↓
Supabase Query
    ↓
Convert JSON to Place objects
    ↓
Update UI with data
```

## 🔧 Customization

### Add More Fields to Place Model

Edit `lib/models/place.dart`:

```dart
class Place {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double? rating;        // Add this
  final String? location;      // Add this
  final double? price;         // Add this
  // ...
}
```

Then update your Supabase table:

```sql
ALTER TABLE places ADD COLUMN rating DECIMAL(2,1);
ALTER TABLE places ADD COLUMN location TEXT;
ALTER TABLE places ADD COLUMN price DECIMAL(10,2);
```

### Change Card Design

Edit `lib/widgets/place_card.dart` to customize:
- Border radius
- Shadow intensity
- Image height
- Text styles
- Colors

### Add Search Functionality

The service already has search built-in:

```dart
await placesProvider.searchPlaces('coffee');
```

## 🐛 Troubleshooting

### "Failed to fetch places"
- Check Supabase credentials in `supabase_config.dart`
- Verify internet connection
- Check Supabase dashboard is accessible

### "Database error: relation 'places' does not exist"
- Run the CREATE TABLE SQL in Supabase
- Check table name is exactly `places` (lowercase)

### Images not loading
- Check image URLs are valid
- Try opening URLs in browser
- Use Unsplash URLs with `?w=800` parameter

### App crashes on start
- Run `flutter clean`
- Run `flutter pub get`
- Check Supabase credentials are correct

## 📚 Files Created

- ✅ `lib/models/place.dart` - Place data model
- ✅ `lib/services/places_service.dart` - Supabase API calls
- ✅ `lib/providers/places_provider.dart` - State management
- ✅ `lib/screens/places_home_screen.dart` - Main screen
- ✅ `lib/widgets/place_card.dart` - Place card widget
- ✅ `SUPABASE_SETUP.md` - Detailed setup guide
- ✅ `QUICK_START.md` - This file!

## 🎯 Next Steps

1. ✅ Add your own places with local images
2. ✅ Implement search functionality
3. ✅ Add place categories
4. ✅ Add user favorites
5. ✅ Add place ratings
6. ✅ Add booking functionality

## 💡 Tips

- Use Unsplash for free placeholder images
- Test with airplane mode to see error states
- Pull down to refresh data
- Tap on cards to see place details

---

**You're all set! 🎉**

Run `flutter run` and watch your app come to life with real Supabase data!
