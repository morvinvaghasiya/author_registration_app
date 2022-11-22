import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Duration duration = const Duration(seconds: 4);
    Timer(duration, () {
      Navigator.of(context).pushReplacementNamed('HomePage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.withOpacity(0.3),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.book_online_rounded,
              color: Colors.amber,
              size: 100,
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Author Registration App ",
              style: GoogleFonts.aBeeZee(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const LinearProgressIndicator(
              color: Colors.teal,
              minHeight: 10,
            ),
          ],
        ),
      ),
    );
  }
}
