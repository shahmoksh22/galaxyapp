import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/theme_provider.dart';
import 'detail_screen.dart';
import 'save_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List planets = [];

  @override
  void initState() {
    super.initState();
    loadJsonFile();
  }

  Future<void> loadJsonFile() async {
    String jsonData = await rootBundle.loadString('assets/json/data.json');
    setState(() {
      planets = jsonDecode(jsonData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.deepPurple[900] : Colors.purpleAccent,
        centerTitle: true,
        title: Text(
          "Galaxy Planets",
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.white,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SaveScreen()));
            },
          )
        ],
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: planets.length,
          itemBuilder: (context, index) {
            final planet = planets[index];
            return Padding(
              padding: const EdgeInsets.only(top:50,bottom: 40),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.deepPurple[800] : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          offset: const Offset(0, 6),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.only(
                        top: 80, left: 16, right: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planet['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.speed,
                                size: 18,
                                color: isDark ? Colors.white70 : Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              'Velocity: ${planet['velocity']} km/s',
                              style: GoogleFonts.poppins(
                                color:
                                isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.timeline,
                                size: 18,
                                color: isDark ? Colors.white70 : Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              'Distance: ${planet['distance']} M km',
                              style: GoogleFonts.poppins(
                                color:
                                isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          planet['description'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: isDark ? Colors.white60 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailScreen(planet: planet),
                                ),
                              );
                            },
                            child: Text("View More",
                                style: GoogleFonts.poppins(
                                  color: isDark
                                      ? Colors.amberAccent
                                      : Colors.deepPurple,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: -60,
                    left: MediaQuery.of(context).size.width * 0.25,
                    child: Hero(
                      tag: planet['name'],
                      child: Image.network(
                        planet['image'],
                        height: 120,
                        width: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
