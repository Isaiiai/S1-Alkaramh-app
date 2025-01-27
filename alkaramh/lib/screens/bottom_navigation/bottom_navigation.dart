import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/cart_screen/cart_screen.dart';
import 'package:alkaramh/screens/home_screen/home_screen.dart';
import 'package:alkaramh/screens/notification_screen/show_notification_screen.dart';
import 'package:alkaramh/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  // List of widgets to show for each screen
  final List<Widget> _screens = [
    HomeScreen(),
    CartScreen(),
    NotificationScreen(),
    AccountScreen(),
  ];

  Widget buildNavItem(String assetPath, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Color(0xFF193219) : Colors.transparent,
      ),
      padding: EdgeInsets.all(8.0), // Adjust padding to make the circle size appropriate
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SvgPicture.asset(
          assetPath,
          color: isSelected ? Colors.white : Colors.grey, // Icon color changes based on selection
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false, // Hide labels
        showUnselectedLabels: false, // Hide labels
        items: [
          BottomNavigationBarItem(
            icon: buildNavItem(bottomNavigationHome, _currentIndex == 0),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: buildNavItem(bottomNavigationCart, _currentIndex == 1),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: buildNavItem(bottomNavigationNotification, _currentIndex == 2),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: buildNavItem(bottomNavigationProfile, _currentIndex == 3),
            label: "",
          ),
        ],
      ),
    );
  }
}

