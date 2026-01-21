
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfessionalBottomNav extends StatefulWidget {
  const ProfessionalBottomNav({super.key});

  @override
  State<ProfessionalBottomNav> createState() => _ProfessionalBottomNavState();
}

class _ProfessionalBottomNavState extends State<ProfessionalBottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // In a real app, this would switch tabs or navigate
      // For this prototype, we stay on Dashboard primarily
      if (index != 0) {
         // Show simple feedback for non-implemented tabs
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This feature is coming soon!"), duration: Duration(milliseconds: 500)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.blue[600],
      unselectedItemColor: Colors.grey[400],
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        _buildNavItem('Dashboard', 'assets/icons/dashboard.svg', 0),
        _buildNavItem('Schedule', 'assets/icons/schedule.svg', 1),
        _buildNavItem('Settings', 'assets/icons/settings.svg', 2),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(String label, String iconPath, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          _selectedIndex == index ? Colors.blue[600]! : Colors.grey[400]!,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}
