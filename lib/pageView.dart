import 'package:flutter/material.dart';
import 'package:rigz/View/home_screen.dart';
import 'package:rigz/View/sign_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class pageViewController extends StatefulWidget {
  @override
  State<pageViewController> createState() => _pageViewControllerState();
}

class _pageViewControllerState extends State<pageViewController> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onTapped,
        children: [homeScreen(), const signScreen(type: "i")],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: _onTapped,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_filled),
            title: const Text("Home"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.account_circle_rounded),
            title: const Text("Account"),
          ),
        ],
      ),
    );
  }
}
