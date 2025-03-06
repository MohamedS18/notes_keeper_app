import 'package:flutter/material.dart';
import 'package:notes_keeper_app/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_keeper_app/home.dart';
import 'package:provider/provider.dart';
import 'states.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => States(), child: MainApp()),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<States>(
      builder: (context, state, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Notes Keeper",
          theme: ThemeData(
            fontFamily: 'Poppins',
            fontFamilyFallback: ['Roboto', 'Arial'],
            textTheme: GoogleFonts.poppinsTextTheme(),
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 255, 7),
            ),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme().apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 255, 7),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/login',
          routes: {
            '/login': (context) => _buildMobileScreen(Login()),
            '/home': (context) => _buildMobileScreen(Home()),
          },
        );
      },
    );
  }

  Widget _buildMobileScreen(Widget screen) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 480),
            child: screen,
          ),
        );
      },
    );
  }
}
