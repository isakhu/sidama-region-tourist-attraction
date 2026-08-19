# Hawassa-Sidama Tour App - Setup Guide

This guide will walk you through setting up the app from scratch. Perfect for beginners!

## Step 1: Install Flutter

### Windows
1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
2. Extract the zip file to a location like `C:\src\flutter`
3. Add Flutter to your PATH:
   - Search for "Environment Variables" in Windows
   - Edit the "Path" variable
   - Add: `C:\src\flutter\bin`
4. Open a new command prompt and run: `flutter doctor`

### macOS
1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/macos
2. Extract and move to desired location
3. Add to PATH in `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
4. Run: `flutter doctor`

### Linux
1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/linux
2. Extract and add to PATH
3. Run: `flutter doctor`

## Step 2: Install Required Tools

### Android Studio (for Android development)
1. Download from: https://developer.android.com/studio
2. Install Android SDK
3. Create an Android Virtual Device (AVD) for testing

### Xcode (for iOS development - macOS only)
1. Install from Mac App Store
2. Run: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
3. Run: `sudo xcodebuild -runFirstLaunch`

### VS Code (Recommended Editor)
1. Download from: https://code.visualstudio.com/
2. Install Flutter extension
3. Install Dart extension

## Step 3: Setup Supabase

1. Go to https://supabase.com and create an account
2. Click "New Project"
3. Fill in project details:
   - Name: hawassa-sidama-tour
   - Database Password: (choose a strong password)
   - Region: (choose closest to your location)
4. Wait for project to be created (takes ~2 minutes)

### Get Your Credentials
1. Go to Project Settings > API
2. Copy your:
   - Project URL (looks like: `https://xxxxx.supabase.co`)
   - Anon/Public Key (long string starting with `eyJ...`)

### Setup Database Tables
1. Go to SQL Editor in Supabase dashboard
2. Copy and paste this SQL:

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tours table
CREATE TABLE tours (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title_en TEXT NOT NULL,
  title_am TEXT,
  title_si TEXT,
  description_en TEXT NOT NULL,
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
  description_en TEXT NOT NULL,
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

-- Insert sample data
INSERT INTO tours (title_en, title_am, title_si, description_en, location, price, duration) VALUES
('Lake Hawassa Boat Tour', 'የሐዋሳ ሀይቅ ጀልባ ጉብኝት', 'Hawassa Haroora Daawwata', 'Enjoy a peaceful boat ride on Lake Hawassa with stunning views of birds and nature.', 'Lake Hawassa', 500, '2 hours'),
('Sidama Coffee Tour', 'የሲዳማ ቡና ጉብኝት', 'Sidama Buna Daawwata', 'Experience the birthplace of coffee with a guided tour of traditional coffee farms.', 'Sidama Region', 800, '4 hours'),
('Fish Market Visit', 'የዓሣ ገበያ ጉብኝት', 'Qurxaa Gabaya Daawwata', 'Visit the famous Hawassa fish market and taste fresh local fish.', 'Hawassa Fish Market', 300, '1.5 hours');

INSERT INTO events (title_en, title_am, title_si, description_en, location, event_date) VALUES
('Fichee Chambalaalla Festival', 'ፊቼ ቻምባላላ በዓል', 'Fichee Chambalaalla Ayyaana', 'Annual Sidama New Year celebration with traditional music, dance, and food.', 'Hawassa Stadium', '2026-06-15 09:00:00+03'),
('Coffee Cultural Festival', 'የቡና ባህል በዓል', 'Buna Aadaa Ayyaana', 'Celebrate Sidama coffee heritage with ceremonies, tastings, and exhibitions.', 'Sidama Cultural Center', '2026-05-20 10:00:00+03');
```

3. Click "Run" to execute the SQL

## Step 4: Configure the App

1. Open `lib/config/supabase_config.dart`
2. Replace the placeholder values:
```dart
static const String supabaseUrl = 'YOUR_ACTUAL_URL_HERE';
static const String supabaseAnonKey = 'YOUR_ACTUAL_KEY_HERE';
```

## Step 5: Install Dependencies

Open terminal in your project folder and run:
```bash
flutter pub get
```

This downloads all required packages.

## Step 6: Run the App

### On Android Emulator
1. Open Android Studio
2. Start an AVD (Android Virtual Device)
3. In terminal, run: `flutter run`

### On iOS Simulator (macOS only)
1. Run: `open -a Simulator`
2. In terminal, run: `flutter run`

### On Physical Device
1. Enable Developer Mode on your phone
2. Connect via USB
3. Run: `flutter run`

## Step 7: Test the App

1. The app should launch and show the home screen
2. Try changing the language using the language icon
3. Browse tours and events
4. Pull down to refresh data

## Troubleshooting

### "Flutter command not found"
- Make sure Flutter is added to your PATH
- Restart your terminal/command prompt

### "No devices found"
- Make sure an emulator is running or device is connected
- Run `flutter devices` to see available devices

### "Supabase connection error"
- Check your internet connection
- Verify your Supabase URL and key are correct
- Make sure you ran the SQL setup script

### "Build failed"
- Run `flutter clean`
- Run `flutter pub get`
- Try again

## Next Steps

Now that your app is running:

1. **Learn the Code**: Read through the comments in each file
2. **Customize**: Change colors, add features, modify text
3. **Add Data**: Add more tours and events in Supabase
4. **Experiment**: Try breaking things and fixing them - that's how you learn!

## Learning Resources

- **Flutter Basics**: https://flutter.dev/docs/get-started/codelab
- **Dart Language**: https://dart.dev/guides/language/language-tour
- **Supabase Docs**: https://supabase.com/docs
- **Flutter Widgets**: https://flutter.dev/docs/development/ui/widgets

## Need Help?

- Flutter Community: https://flutter.dev/community
- Stack Overflow: Tag your questions with `flutter`
- Supabase Discord: https://discord.supabase.com

Happy coding! 🎉
