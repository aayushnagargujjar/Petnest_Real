import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petnest/screens/authentication/login_screen.dart';
import 'package:petnest/screens/authentication/start_screen.dart';
import 'package:petnest/screens/home/home_screen.dart';
import 'package:petnest/screens/shop/shop_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 1. Setup Animation (Fade In)
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // 2. Start Timer to check Login status
    Timer(const Duration(seconds: 3), _checkAuthAndNavigate);
  }

  // --- 🧠 SMART NAVIGATION LOGIC ---
  void _checkAuthAndNavigate() {
    // Check if user is logged in via Firebase
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacementNamed('/app');
    } else {
      // User is NOT logged in -> Go to Login
      // Navigator.of(context).pushReplacementNamed('/login'); // Use this if you have routes
      // OR
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));

      // For now, I'll send to ShopScreen just so you can test,
      // BUT you should uncomment the Login line above when you have a Login Screen!
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StartScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600], // Brand Color
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ClipOval(
                child: Image.asset('assets/icons/logopng.png'
                  ,width: 100,height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'PetNest',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Everything your pet❤ needs',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              // --- LOADING INDICATOR ---
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}