import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:practice_interview/provider_task.dart';
import 'package:practice_interview/home.dart';

// Ledger palette — ek hi accent (pine), baaki neutral paper/ink tones
class AppColors {
  static const paper = Color(0xFFFAF6EE);
  static const line = Color(0xFFDDD5C3);
  static const ink = Color(0xFF1F2A22);
  static const inkMuted = Color(0xFF6B6A5D);
  static const pine = Color(0xFF2F4F3D);
  static const pineTint = Color(0xFFE4EAE3);
  static const clay = Color(0xFFA6533C);
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProviderTask(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseText = GoogleFonts.interTextTheme();

    return MaterialApp(
      title: 'To-Do',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.pine,
          primary: AppColors.pine,
          surface: AppColors.paper,
          error: AppColors.clay,
        ),
        textTheme: baseText.copyWith(
          // Fraunces sirf headline-jaisi jagah pe — task titles, dialog title
          headlineSmall: GoogleFonts.fraunces(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
          titleLarge: GoogleFonts.fraunces(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
          bodyLarge: baseText.bodyLarge?.copyWith(color: AppColors.ink),
          bodyMedium: baseText.bodyMedium?.copyWith(color: AppColors.ink),
          bodySmall: baseText.bodySmall?.copyWith(color: AppColors.inkMuted),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.paper,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.ink,
          titleTextStyle: GoogleFonts.fraunces(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.line,
          thickness: 1,
          space: 1,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pine,
            foregroundColor: AppColors.paper,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.clay,
            side: const BorderSide(color: AppColors.clay),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.pine,
          foregroundColor: AppColors.paper,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.line),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.pine, width: 1.5),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.clay),
          ),
          hintStyle: GoogleFonts.inter(color: AppColors.inkMuted),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}