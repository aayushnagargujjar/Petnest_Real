
import 'package:flutter/material.dart';
import 'package:petnest/screens/home/home_screen.dart';
import 'package:petnest/screens/shop/shop_screen.dart';
import 'package:petnest/screens/services/services_screen.dart';
import 'package:petnest/screens/pets/pets_screen.dart';
import 'package:petnest/screens/profile/profile_screen.dart';
import 'package:petnest/widgets/customer_bottom_nav.dart';
import 'package:petnest/widgets/main_app_bar.dart';

class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ShopScreen(),
    ServicesScreen(),
    PetsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: CustomerBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
