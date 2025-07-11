import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:galaxyapp/providers/theme_provider.dart';
import 'Home_Page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late Animation<Offset> _titleOffset;
  late AnimationController _subtitleController;
  late Animation<double> _subtitleFade;
  late Animation<double> _subtitleScale;
  late AnimationController _quoteController;
  late Animation<double> _quoteFade;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _quoteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _titleOffset = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    ));

    _subtitleFade = CurvedAnimation(
      parent: _subtitleController,
      curve: Curves.easeIn,
    );

    _subtitleScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeOut),
    );

    _quoteFade = CurvedAnimation(
      parent: _quoteController,
      curve: Curves.easeIn,
    );

    _titleController.forward();
    Timer(const Duration(milliseconds: 800), () {
      _subtitleController.forward();
    });
    Timer(const Duration(milliseconds: 1600), () {
      _quoteController.forward();
    });

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            "assets/images/galaxy.jpg",
            fit: BoxFit.cover,
          ),

          // Overlay
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          // Animated texts
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title: Slide + Fade
                SlideTransition(
                  position: _titleOffset,
                  child: Text(
                    "Galaxy Planet",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color:
                      isDark ? Colors.white : Colors.deepPurple.shade100,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Subtitle: Fade + Scale
                FadeTransition(
                  opacity: _subtitleFade,
                  child: ScaleTransition(
                    scale: _subtitleScale,
                    child: Text(
                      "Explore the universe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color:
                        isDark ? Colors.white70 : Colors.deepPurple.shade50,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Tagline/Quote: Fade-in later
                FadeTransition(
                  opacity: _quoteFade,
                  child: Text(
                    "\"Every star has a story.\"",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? Colors.white54
                          : Colors.deepPurple.shade200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
