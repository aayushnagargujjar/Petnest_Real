
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomerBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.blue[600],
      unselectedItemColor: Colors.grey[400],
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        _buildNavItem('Home', 'assets/icons/home.svg', 0),
        _buildNavItem('Shop', 'assets/icons/store.svg', 1),
        _buildNavItem('Services', 'assets/icons/grid.svg', 2),
        _buildNavItem('Pets', 'assets/icons/heart.svg', 3),
        _buildNavItem('Profile', 'assets/icons/user.svg', 4),
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
          selectedIndex == index ? Colors.blue[600]! : Colors.grey[400]!,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}
