# Supabase Setup Guide for Places Table

This guide will help you set up your Supabase database with the 'places' table.

## Step 1: Create Supabase Project

1. Go to https://supabase.com and sign in
2. Click "New Project"
3. Fill in:
   - **Name**: hawassa-sidama-tour
   - **Database Password**: (choose a strong password and save it!)
   - **Region**: Choose closest to your location
4. Wait 2-3 minutes for project creation

## Step 2: Get Your Credentials

1. Go to **Project Settings** (gear icon in sidebar)
2. Click **API** in the left menu
3. Copy these values:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon/public key**: Long string starting with `eyJ...`

## Step 3: Add Credentials to Your App

1. Open `lib/config/supabase_config.dart`
2. Replace the placeholder values:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
}
```

## Step 4: Create the 'places' Table

1. In Supabase dashboard, go to **SQL Editor**
2. Click **New Query**
3. Copy and paste this SQL:

```sql
-- Enable UUID extension (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create places table
CREATE TABLE places (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE places ENABLE ROW LEVEL SECURITY;

-- Create policy to allow public read access
CREATE POLICY "Public places are viewable by everyone"
  ON places FOR SELECT
  USING (true);

-- Optional: Create policy for authenticated users to insert
CREATE POLICY "Authenticated users can insert places"
  ON places FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- Insert sample data
INSERT INTO places (name, description, image_url) VALUES
(
  'Lake Hawassa',
  'A beautiful freshwater lake in the Great Rift Valley, known for its stunning sunsets and diverse birdlife. Perfect for boat tours and relaxation.',
  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'
),
(
  'Sidama Coffee Farms',
  'Experience the birthplace of coffee with guided tours through traditional coffee farms. Learn about the coffee-making process from bean to cup.',
  'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=800'
),
(
  'Hawassa Fish Market',
  'A vibrant local market where fishermen bring their daily catch. Taste fresh fish prepared in traditional Ethiopian style.',
  'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800'
),
(
  'Fichee Chambalaalla Festival Ground',
  'The cultural heart of Sidama where the annual New Year celebration takes place with traditional music, dance, and ceremonies.',
  'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800'
),
(
  'Wondo Genet Hot Springs',
  'Natural hot springs surrounded by lush forest. A perfect spot for relaxation and enjoying nature.',
  'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800'
);
```

4. Click **Run** (or press Ctrl+Enter)
5. You should see "Success. No rows returned"

## Step 5: Verify Your Data

1. Go to **Table Editor** in Supabase
2. Select the **places** table
3. You should see 5 sample places with:
   - id (UUID)
   - name
   - description
   - image_url
   - created_at

## Step 6: Test the Connection

1. Make sure you've added your credentials to `supabase_config.dart`
2. Run your Flutter app:
   ```bash
   flutter pub get
   flutter run
   ```
3. The app should:
   - Show a loading indicator
   - Fetch places from Supabase
   - Display them in cards

## Troubleshooting

### Error: "Failed to fetch places"

**Check:**
- ✅ Supabase URL and key are correct in `supabase_config.dart`
- ✅ Internet connection is working
- ✅ Table name is exactly `places` (lowercase)
- ✅ Row Level Security policy allows public read access

**Solution:**
```sql
-- Run this in SQL Editor to check policies
SELECT * FROM pg_policies WHERE tablename = 'places';

-- If no policies exist, create one:
CREATE POLICY "Public places are viewable by everyone"
  ON places FOR SELECT
  USING (true);
```

### Error: "Database error: relation 'places' does not exist"

**Solution:**
- The table wasn't created. Run the CREATE TABLE SQL again.

### Images not loading

**Check:**
- ✅ `image_url` column has valid URLs
- ✅ URLs are accessible (try opening in browser)
- ✅ Internet connection is working

**Solution:**
- Use placeholder images from Unsplash or other free image services
- Or leave `image_url` as NULL to use gradient placeholders

## Adding More Places

### Option 1: Using Supabase Dashboard
1. Go to **Table Editor**
2. Click **Insert row**
3. Fill in:
   - name: "Your Place Name"
   - description: "Your description"
   - image_url: "https://your-image-url.com/image.jpg" (optional)
4. Click **Save**

### Option 2: Using SQL
```sql
INSERT INTO places (name, description, image_url) VALUES
('New Place', 'Amazing description', 'https://image-url.com/pic.jpg');
```

### Option 3: Using the App (Future Feature)
You can add an admin panel to your app to create places directly.

## Image URL Sources

Free image sources you can use:
- **Unsplash**: https://unsplash.com (add `?w=800` to resize)
- **Pexels**: https://pexels.com
- **Pixabay**: https://pixabay.com

Example Unsplash URL:
```
https://images.unsplash.com/photo-1234567890?w=800
```

## Security Notes

⚠️ **Important:**
- The current setup allows **public read access** to places
- Anyone can view places without authentication
- Only authenticated users can insert new places (if you enabled that policy)
- For production, consider adding more security policies

## Next Steps

1. ✅ Add your own places with local images
2. ✅ Customize the place model to add more fields (rating, location, price, etc.)
3. ✅ Add search functionality
4. ✅ Add categories/tags for places
5. ✅ Add user authentication for favorites

## Need Help?

- **Supabase Docs**: https://supabase.com/docs
- **Supabase Discord**: https://discord.supabase.com
- **Flutter Supabase Package**: https://pub.dev/packages/supabase_flutter

---

**Happy Building! 🚀**
