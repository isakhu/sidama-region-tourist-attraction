# ✅ ESSENTIAL CHECKLIST - What You MUST Do

## 🔴 CRITICAL (App won't work without these):

### 1. Install Flutter
- [ ] Download Flutter SDK
- [ ] Add to PATH
- [ ] Run `flutter doctor`
- [ ] Fix any issues shown

### 2. Install Android Studio
- [ ] Download and install
- [ ] Install Android SDK
- [ ] Create virtual device (AVD)
- [ ] Accept licenses: `flutter doctor --android-licenses`

### 3. Setup Supabase
- [ ] Create Supabase account
- [ ] Create new project
- [ ] Copy Project URL
- [ ] Copy Anon Key
- [ ] Paste in `lib/config/supabase_config.dart`
- [ ] Run SQL to create `places` table
- [ ] Add sample data

### 4. Setup Google Maps
- [ ] Get Google Maps API key
- [ ] Add to `AndroidManifest.xml`
- [ ] Enable Maps SDK in Google Cloud

### 5. Install Dependencies
```bash
flutter pub get
```

### 6. Run App
```bash
flutter run
```

---

## 🟡 OPTIONAL (Nice to have):

### For iOS (if you have Mac):
- [ ] Install Xcode
- [ ] Add Maps key to `AppDelegate.swift`
- [ ] Run `cd ios && pod install`

### For Better Experience:
- [ ] Add more places to database
- [ ] Add real images (not Unsplash)
- [ ] Add real coordinates for your area
- [ ] Customize colors in `app_theme.dart`

---

## 📦 WHAT'S ALREADY DONE:

✅ Complete Flutter project structure
✅ Supabase integration
✅ Google Maps integration
✅ 3 languages (English, Amharic, Sidaamu Afoo)
✅ Home screen with places
✅ Map view with markers
✅ Place detail screen
✅ Settings screen
✅ Language switcher
✅ Loading/error states
✅ Smooth animations
✅ Pull-to-refresh
✅ Premium UI design

---

## 🎯 MINIMUM TO RUN:

**Just these 3 things:**
1. Flutter installed
2. Supabase credentials added
3. Google Maps API key added

Then run:
```bash
flutter pub get
flutter run
```

**That's it! 🚀**

---

## 📱 TO TEST ON YOUR PHONE:

### Android:
1. Enable Developer Mode on phone
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter run`

### Or use emulator:
1. Open Android Studio
2. Start AVD
3. Run: `flutter run`

---

## ⏱️ TIME ESTIMATE:

- Flutter setup: 15 min
- Android Studio: 10 min
- Supabase: 5 min
- Google Maps: 5 min
- Run app: 2 min

**Total: ~40 minutes**

---

## 🆘 QUICK FIXES:

**App crashes on start:**
```bash
flutter clean
flutter pub get
flutter run
```

**Map not showing:**
- Check API key in `AndroidManifest.xml`
- Enable Maps SDK in Google Cloud Console

**No data showing:**
- Check Supabase credentials
- Verify internet connection
- Check SQL table was created

**Build errors:**
```bash
flutter clean
rm -rf build/
flutter pub get
flutter run
```

---

**You're ready to go! 🎉**
