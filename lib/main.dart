import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const FoodHouseApp());
}

class FoodHouseApp extends StatelessWidget {
  const FoodHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food House',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Montserrat',

        scaffoldBackgroundColor:
            const Color(0xFFF6F1E9),

        colorScheme: ColorScheme.fromSeed(
          seedColor:
              const Color(0xFF0B1F3A),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor:
              Color(0xFF0B1F3A),
          foregroundColor:
              Colors.white,
          centerTitle: true,
          elevation: 0,
        ),

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(
                    0xFF0B1F3A),
            foregroundColor:
                Colors.white,
            elevation: 0,
            minimumSize:
                const Size(
                    double.infinity,
                    55),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                      16),
            ),
          ),
        ),

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    16),
            borderSide:
                BorderSide.none,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
