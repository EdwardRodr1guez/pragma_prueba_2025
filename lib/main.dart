import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pragma_prueba/pages/landing_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return const CupertinoApp(
            debugShowCheckedModeBanner: false,
            title: 'Catbreeds iOS',
            home: LandingPage());
      default:
        return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Catbreeds Android',
            home: LandingPage());
    }
  }
}
