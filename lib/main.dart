
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/posts_screen.dart';
import 'screens/details_screen.dart';
import 'screens/favorites_screen.dart';

const Color night = Color(0xFF071943);
const Color deepBlue = Color(0xFF0B245B);
const Color panelBlue = Color(0xE8112B69);
const Color cyan = Color(0xFF35D8FF);
const Color violet = Color(0xFF9A52FF);
const Color pink = Color(0xFFFF5CCB);
const Color textLight = Color(0xFFF4F6FF);
const Color textMuted = Color(0xFFB7C6F2);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('favoritesBox');

  runApp(const PostReaderApp());
}

class PostReaderApp extends StatelessWidget {
  const PostReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Reader & Favorites',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: night,
        fontFamily: 'Roboto',

        colorScheme: ColorScheme.fromSeed(
          seedColor: violet,
          brightness: Brightness.dark,
        ).copyWith(
          primary: cyan,
          secondary: violet,
          surface: const Color(0xFF10265A),
          error: const Color(0xFFFF6B7A),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: textLight,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: textLight,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xD9162E6B),
          hintStyle: const TextStyle(color: textMuted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0x6635D8FF),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0x5535D8FF),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: cyan,
              width: 1.5,
            ),
          ),
        ),

        cardTheme: CardThemeData(
          color: const Color(0xE8102458),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(
              color: Color(0x553C8CFF),
            ),
          ),
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const PostsScreen(),
        '/details': (context) => const DetailsScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}
