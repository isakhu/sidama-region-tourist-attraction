/// Supabase Configuration
/// This file stores your Supabase project credentials
/// 
/// IMPORTANT: Replace these values with your actual Supabase project details
/// You can find these in your Supabase dashboard under Settings > API

class SupabaseConfig {
  // Your Supabase project URL
  // Example: 'https://xyzcompany.supabase.co'
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  
  // Your Supabase anonymous key (public key)
  // This is safe to use in client-side code
  // Example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // NOTE: Never commit your actual keys to public repositories!
  // For production apps, use environment variables or secure storage
}
