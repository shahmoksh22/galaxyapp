import 'package:flutter/material.dart';
import 'package:galaxyapp/providers/theme_provider.dart';
import 'package:galaxyapp/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Galaxy Planet',
            theme: ThemeProvider.getTheme(),
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
