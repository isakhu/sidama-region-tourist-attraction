# Learning Notes - Understanding the Code

This document explains key concepts in the app to help you learn Flutter and Dart.

## Project Structure

```
lib/
├── main.dart                    # App entry point - starts here!
├── config/                      # Configuration files
│   └── supabase_config.dart    # Backend connection settings
├── models/                      # Data structures
│   ├── tour.dart               # Tour data model
│   └── event.dart              # Event data model
├── providers/                   # State management
│   ├── language_provider.dart  # Manages language changes
│   └── tour_provider.dart      # Manages tours/events data
├── screens/                     # Full-page views
│   ├── home_screen.dart        # Main landing page
│   ├── tours_screen.dart       # All tours page
│   ├── events_screen.dart      # All events page
│   └── tour_detail_screen.dart # Single tour details
├── widgets/                     # Reusable UI components
│   ├── tour_card.dart          # Tour display card
│   └── event_card.dart         # Event display card
├── services/                    # Backend communication
│   └── supabase_service.dart   # Database operations
├── l10n/                        # Translations
│   ├── app_en.arb              # English translations
│   ├── app_am.arb              # Amharic translations
│   └── app_si.arb              # Sidaamu Afoo translations
└── theme/                       # Visual styling
    └── app_theme.dart          # Colors, fonts, styles
```

## Key Concepts

### 1. Widgets
Everything in Flutter is a widget! Widgets are building blocks of the UI.

**Types:**
- **StatelessWidget**: Doesn't change (static)
- **StatefulWidget**: Can change (dynamic)

**Example:**
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Hello!');
  }
}
```

### 2. State Management (Provider)
Provider helps share data across the app without passing it through every widget.

**How it works:**
1. Create a provider class (extends ChangeNotifier)
2. Call `notifyListeners()` when data changes
3. Use `Consumer` or `Provider.of` to access data

**Example:**
```dart
// In provider
class MyProvider extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners(); // Updates UI
  }
}

// In widget
Consumer<MyProvider>(
  builder: (context, provider, child) {
    return Text('Count: ${provider.count}');
  },
)
```

### 3. Async/Await
Used for operations that take time (like fetching data from internet).

**Example:**
```dart
Future<void> fetchData() async {
  // Wait for data from server
  final data = await supabase.from('tours').select();
  // Continue after data arrives
  print(data);
}
```

### 4. Models
Models are classes that represent data structures.

**Why use them?**
- Type safety (catch errors early)
- Easy to work with data
- Convert between JSON and Dart objects

**Example:**
```dart
class Tour {
  final String id;
  final String title;
  
  Tour({required this.id, required this.title});
  
  // Convert JSON to Tour object
  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'],
      title: json['title'],
    );
  }
}
```

### 5. Navigation
Moving between screens.

**Example:**
```dart
// Go to new screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Go back
Navigator.pop(context);
```

### 6. Localization (Multiple Languages)
Supporting multiple languages in the app.

**How it works:**
1. Define translations in `.arb` files
2. Use `AppLocalizations.of(context)` to get translations
3. Change locale to switch languages

**Example:**
```dart
// In code
Text(AppLocalizations.of(context)!.welcomeMessage)

// In app_en.arb
"welcomeMessage": "Welcome!"

// In app_am.arb
"welcomeMessage": "እንኳን ደህና መጡ!"
```

## Common Patterns

### 1. Loading States
Show loading indicator while fetching data:
```dart
if (isLoading) {
  return CircularProgressIndicator();
} else {
  return DataWidget();
}
```

### 2. Error Handling
Handle errors gracefully:
```dart
try {
  await fetchData();
} catch (e) {
  print('Error: $e');
  // Show error message to user
}
```

### 3. Pull to Refresh
Let users refresh data:
```dart
RefreshIndicator(
  onRefresh: () => fetchData(),
  child: ListView(...),
)
```

## Supabase Basics

### Fetching Data
```dart
// Get all tours
final data = await supabase.from('tours').select();

// Get specific tour
final tour = await supabase
  .from('tours')
  .select()
  .eq('id', tourId)
  .single();

// Search
final results = await supabase
  .from('tours')
  .select()
  .ilike('title', '%search%');
```

### Inserting Data
```dart
await supabase.from('tours').insert({
  'title': 'New Tour',
  'location': 'Hawassa',
});
```

### Updating Data
```dart
await supabase
  .from('tours')
  .update({'title': 'Updated Title'})
  .eq('id', tourId);
```

### Deleting Data
```dart
await supabase
  .from('tours')
  .delete()
  .eq('id', tourId);
```

## Tips for Learning

1. **Read the comments**: Every file has detailed comments explaining what the code does

2. **Experiment**: Try changing things and see what happens
   - Change colors in `app_theme.dart`
   - Modify text in `.arb` files
   - Add new fields to models

3. **Use hot reload**: Press `r` in terminal while app is running to see changes instantly

4. **Debug**: Use `print()` statements to see what's happening
   ```dart
   print('Current language: $languageCode');
   ```

5. **Break things**: Don't be afraid to break the app - that's how you learn!

6. **Ask questions**: Use Stack Overflow, Flutter Discord, or Reddit

## Next Steps

1. **Add authentication**: Let users sign up and log in
2. **Add favorites**: Let users save favorite tours
3. **Add booking**: Implement tour booking functionality
4. **Add reviews**: Let users rate and review tours
5. **Add maps**: Show tour locations on a map
6. **Add images**: Upload and display tour images

## Resources

- **Flutter Documentation**: https://flutter.dev/docs
- **Dart Language Tour**: https://dart.dev/guides/language/language-tour
- **Flutter Widget Catalog**: https://flutter.dev/docs/development/ui/widgets
- **Supabase Docs**: https://supabase.com/docs
- **Provider Package**: https://pub.dev/packages/provider

## Common Errors and Solutions

### "Null check operator used on a null value"
- **Cause**: Trying to use a value that doesn't exist
- **Solution**: Use null-safe operators (`?.`, `??`)

### "setState() called after dispose()"
- **Cause**: Trying to update a widget that's been removed
- **Solution**: Check if widget is still mounted before calling setState

### "RenderFlex overflowed"
- **Cause**: Widget is too big for its container
- **Solution**: Wrap in `Expanded`, `Flexible`, or `SingleChildScrollView`

Happy learning! 🚀
