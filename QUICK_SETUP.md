# ⚡ QUICK SETUP - Get Your App Running NOW

## 🚀 STEP 1: Install Flutter (15 minutes)

### Windows:
1. Download: https://docs.flutter.dev/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`
4. Run: `flutter doctor`

### Mac:
```bash
brew install flutter
flutter doctor
```

### Linux:
```bash
sudo snap install flutter --classic
flutter doctor
```

## 📱 STEP 2: Install Android Studio (10 minutes)

1. Download: https://developer.android.com/studio
2. Install Android SDK
3. Create Virtual Device (AVD)
4. Run: `flutter doctor --android-licenses` (accept all)

## 🔑 STEP 3: Setup Supabase (5 minutes)

1. Go to https://supabase.com
2. Create account + new project
3. Copy **Project URL** and **Anon Key**
4. Open `lib/config/supabase_config.dart`
5. Paste your credentials:

```dart
static const String supabaseUrl = 'YOUR_URL_HERE';
static const String supabaseAnonKey = 'YOUR_KEY_HERE';
```

6. Go to SQL Editor in Supabase, run this:

```sql
CREATE TABLE places (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  image_url TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE places ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public places" ON places FOR SELECT USING (true);

INSERT INTO places (name, description, image_url, latitude, longitude) VALUES
('Lake Hawassa', 'Beautiful lake with stunning sunsets', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 7.0621, 38.4776),
('Sidama Coffee Farms', 'Experience the birthplace of coffee', 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=800', 6.8500, 38.5000);
```

## 🗺️ STEP 4: Setup Google Maps (5 minutes)

1. Go to https://console.cloud.google.com/
2. Create project
3. Enable "Maps SDK for Android"
4. Create API Key
5. Open `android/app/src/main/AndroidManifest.xml`
6. Add inside `<application>` tag:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_KEY"/>
```

## ▶️ STEP 5: Run the App (2 minutes)

```bash
cd your-project-folder
flutter pub get
flutter run
```

---

## ✅ WHAT WORKS NOW:

- ✅ Home screen with places from Supabase
- ✅ Map view with markers
- ✅ Place details with embedded map
- ✅ Language switching (English, Amharic, Sidaamu Afoo)
- ✅ Settings screen
- ✅ Pull-to-refresh
- ✅ Loading/error states
- ✅ Smooth animations

---

## 🎯 WHAT TO ADD NEXT (Optional):

### Easy (30 min each):
1. **Search functionality** - Already coded, just add search bar
2. **Favorites** - Save favorite places locally
3. **Dark mode** - Add theme toggle
4. **Share places** - Share via social media

### Medium (1-2 hours each):
5. **User authentication** - Login/signup with Supabase
6. **Booking system** - Book tours
7. **Reviews & ratings** - Rate places
8. **Photo gallery** - Multiple images per place

### Advanced (3+ hours each):
9. **Offline mode** - Cache data locally
10. **Push notifications** - Event reminders
11. **Payment integration** - Accept payments
12. **Admin panel** - Manage places from app

---

## 🐛 TROUBLESHOOTING:

**"Flutter not found"**
- Add Flutter to PATH and restart terminal

**"No devices found"**
- Start Android emulator or connect phone via USB

**"Supabase error"**
- Check credentials in `supabase_config.dart`
- Verify internet connection

**"Map not showing"**
- Check Google Maps API key
- Enable Maps SDK in Google Cloud Console

**"Build failed"**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📞 NEED HELP?

- Flutter Docs: https://flutter.dev/docs
- Supabase Docs: https://supabase.com/docs
- Stack Overflow: Tag with `flutter`

---

**Total Setup Time: ~40 minutes**
**Then you're LIVE! 🎉**
