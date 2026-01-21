
import 'package:flutter/material.dart';
import 'package:petnest/models/product.dart';
import 'package:petnest/screens/authentication/Splashscreen.dart';
import 'package:petnest/screens/authentication/app_shell_controller.dart';
import 'package:petnest/screens/order/booking_screen.dart';
import 'package:petnest/screens/order/cart_screen.dart';
import 'package:petnest/screens/order/order_summary_screen.dart';
import 'package:petnest/screens/order/order_tracking_screen.dart';
import 'package:petnest/screens/order/payment_screen.dart';
import 'package:petnest/screens/pets/pet_detail_screen.dart';
import 'package:petnest/screens/shop/product_detail_screen.dart';
import 'package:provider/provider.dart';
//google
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:petnest/providers/cart_provider.dart';
import 'package:petnest/providers/user_provider.dart';
import 'package:petnest/screens/authentication/start_screen.dart';
import 'package:petnest/screens/authentication/login_screen.dart';
import 'package:petnest/screens/authentication/signup_screen.dart';

import 'package:petnest/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PetNestApp());
}

class PetNestApp extends StatelessWidget {
  const PetNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'PetNest',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black87),
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/start': (context) => const StartScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/app': (context) => const AppShellController(),
          '/app/cart': (context) => const CartScreen(),
          '/app/product-detail': (context) => const Placeholder(),
          '/app/pet-detail': (context) => const PetDetailScreen(),
          '/app/booking': (context) => const BookingScreen(),
          '/app/order-summary': (context) => const OrderSummaryScreen(),
          '/app/payment': (context) => const PaymentScreen(),
          '/app/tracking': (context) => const OrderTrackingScreen(),
        },
      ),
    );
  }
}
