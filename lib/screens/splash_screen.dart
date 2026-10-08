import 'dart:async';
import 'package:keeps_note_clone/utils/screens.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  void _navigateToHomePage() async {
    await Future.delayed(const Duration(seconds: 2));
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, Screens.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FlutterLogo(size: 80)
    );
  }
}
