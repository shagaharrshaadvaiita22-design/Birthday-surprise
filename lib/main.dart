import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/birthday_config.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;
  final config = await BirthdayConfig.load();
  runApp(BirthdaySurpriseApp(config: config));
}

class BirthdaySurpriseApp extends StatelessWidget {
  final BirthdayConfig config;

  const BirthdaySurpriseApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Surprise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF2C101B),
        primaryColor: const Color(0xFFE05688),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE05688),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: LoginScreen(config: config),
    );
  }
}
