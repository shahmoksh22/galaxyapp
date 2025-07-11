import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Map planet;

  const DetailScreen({super.key, required this.planet});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _fadeInAnimation;
  late AnimationController _fadeController;

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
    _loadFavoriteStatus();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      isFavorite = favorites.contains(widget.planet['name']);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      if (isFavorite) {
        favorites.remove(widget.planet['name']);
      } else {
        favorites.add(widget.planet['name']);
      }
      isFavorite = !isFavorite;
    });

    await prefs.setStringList('favorites', favorites);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Planet Info",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.amberAccent,
            ),
            onPressed: _toggleFavorite,
          )
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.black, Colors.deepPurple.shade900]
                    : [Colors.purple.shade50, Colors.deepPurple.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Foreground content with safe area
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: Hero(
                      tag: widget.planet['name'],
                      child: Image.network(
                        widget.planet['image'],
                        height: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Text("Image error"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: Column(
                      children: [
                        Text(
                          widget.planet['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : Colors.deepPurple.shade800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.planet['description'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _infoTile(
                              icon: Icons.speed,
                              label: 'Velocity',
                              value: '${widget.planet['velocity']} km/s',
                              isDark: isDark,
                            ),
                            _infoTile(
                              icon: Icons.timeline,
                              label: 'Distance',
                              value: '${widget.planet['distance']} M km',
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(icon, color: isDark ? Colors.white70 : Colors.deepPurple),
        const SizedBox(height: 6),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87)),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.deepPurple.shade900,
            )),
      ],
    );
  }
}
