import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

// TODO: Replace with your actual Supabase project URL and anon key
// Get these from: https://app.supabase.com → Project Settings → API
const String supabaseUrl = 'https://ffudnpmnrhrqfqqygcnz.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZmdWRucG1ucmhycWZxcXlnY256Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYwMDk5MDYsImV4cCI6MjA5MTU4NTkwNn0.ZH_H5cE3O5UoIxORkaOcSJ5DIXpI7mGqMbD_WfRGZVo';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: GymRankApp(),
    ),
  );
}
