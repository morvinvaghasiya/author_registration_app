import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/Home_Page.dart';
import 'pages/Splash_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'SplashScreen',
        routes: {
          'HomePage': (context) => const HomePage(),
          'SplashScreen': (context) => const SplashScreen(),
        }),
  );
}
