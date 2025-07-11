import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  List<Map<String, dynamic>> allPlanets = [];
  List<String> favoriteNames = [];
  List<Map<String, dynamic>> favoritePlanets = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadJson();
  }

  Future<void> _loadJson() async {
    final jsonStr = await rootBundle.loadString('assets/json/data.json');
    final List<dynamic> data = json.decode(jsonStr);
    setState(() {
      allPlanets = data.cast<Map<String, dynamic>>();
      _filterFavorites();
    });
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteNames = prefs.getStringList('favorites') ?? [];
    });
    _filterFavorites();
  }

  void _filterFavorites() {
    favoritePlanets = allPlanets
        .where((planet) => favoriteNames.contains(planet['name']))
        .toList();
  }

  Future<void> _removeFromFavorites(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteNames.remove(name);
      favoritePlanets.removeWhere((p) => p['name'] == name);
    });
    await prefs.setStringList('favorites', favoriteNames);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Favorite Planets", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black, Colors.deepPurple.shade900]
                : [Colors.purple.shade50, Colors.deepPurple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadFavorites();
            await _loadJson();
          },
          child: favoritePlanets.isEmpty
              ? Center(
            child: Text(
              "No favorites yet!",
              style: GoogleFonts.poppins(fontSize: 18, color: isDark ? Colors.white70 : Colors.black87),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoritePlanets.length,
            itemBuilder: (context, i) {
              final planet = favoritePlanets[i];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.deepPurple.withOpacity(0.2)
                          : Colors.deepPurple.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    planet['name'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: isDark ? Colors.white : Colors.deepPurple.shade900,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Velocity: ${planet['velocity']} km/s\nDistance: ${planet['distance']} M km",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _removeFromFavorites(planet['name']),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
