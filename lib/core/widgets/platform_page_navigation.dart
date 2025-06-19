import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformMainNavigation extends StatelessWidget {
  final int currentIndex;
  final List<Widget> pages;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;

  const PlatformMainNavigation({
    super.key,
    required this.currentIndex,
    required this.pages,
    required this.onTap,
    required this.items,
    required this.backgroundColor,
    required this.selectedItemColor,
    required this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    final navBar = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              if (index == 2) {
                return GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                );
              } else {
                return _buildNavIcon(
                  index,
                  items[index].icon,
                  selectedItemColor,
                  unselectedItemColor,
                );
              }
            }),
          ),
        ),
      ),
    );

    if (Platform.isIOS) {
      return Scaffold(
        body: Stack(
          children: [
            IndexedStack(index: currentIndex, children: pages),
            Positioned(left: 0, right: 0, bottom: 0, child: navBar),
          ],
        ),
      );
    }

    return Scaffold(body: pages[currentIndex], bottomNavigationBar: navBar);
  }

  Widget _buildNavIcon(
    int index,
    Widget icon,
    Color selectedColor,
    Color unselectedColor,
  ) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: IconTheme(
          data: IconThemeData(
            size: 28,
            color: currentIndex == index ? selectedColor : unselectedColor,
          ),
          child: icon,
        ),
      ),
    );
  }
}
