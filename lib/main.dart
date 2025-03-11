import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test/pages/homepage.dart';
import 'package:test/services/database_service.dart';
import 'package:test/services/http_service.dart';

void main() async {
  await _setupServices();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _setupServices() async {
  GetIt.instance.registerSingleton<HTTPService>(HTTPService());
  GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokimon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
        textTheme: GoogleFonts.quattrocentoTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}
