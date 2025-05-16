import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://ejegwqxipzmcurnvxkor.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqZWd3cXhpcHptY3VybnZ4a29yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0OTg3ODcsImV4cCI6MjA2MTA3NDc4N30.DoAY-2ni_ovcRjDSq9Lby5_Z7lKBRVvW7LYAszMb2T4';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
