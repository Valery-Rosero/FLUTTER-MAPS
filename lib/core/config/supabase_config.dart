import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://kjzcotwnjsxwigodspal.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtqemNvdHduanN4d2lnb2RzcGFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjExNjQwMzYsImV4cCI6MjA3Njc0MDAzNn0.eT04n3n4rdqhb2TYAfZHgyKKcLL84LOK7FIs3HdlBTQ';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
