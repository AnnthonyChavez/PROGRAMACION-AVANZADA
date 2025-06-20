import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          titleMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.green.shade900,
          ),
          bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          bodySmall: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700),
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F5F4),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIconColor: Colors.green.shade800,
          labelStyle: TextStyle(color: Colors.green.shade800),
        ),
        cardTheme: CardThemeData( // ← este cambio es clave
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadowColor: Colors.greenAccent,
          elevation: 4,
        ),
      ),
      home: const HomePage(),
    );
  }
}