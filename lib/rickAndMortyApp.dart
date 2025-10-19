import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/View/favorite/Favorite_screen.dart';
import 'package:rick_and_morty_app/View/home/homeScreen.dart';





class RickAndMortyApp extends StatefulWidget {
  const RickAndMortyApp({super.key});

  @override
  State<RickAndMortyApp> createState() => _RickAndMortyAppState();
}

class _RickAndMortyAppState extends State<RickAndMortyApp> {
  int _selectedPageIndex = 0;
  final PageController _pageController = PageController();

  static final List<Widget> _pages = [
    HomeScreen(),
    FavoritesScreen()
  ];

    @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_selectedPageIndex != index) {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

    void _onNavBarTap(int index) {
    if (_selectedPageIndex != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const BouncingScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onNavBarTap,
          currentIndex: _selectedPageIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
            BottomNavigationBarItem(icon: Icon(Icons.star_border), label: "Избранные"),
          
          ],
        ),
      ),
    );
  }
}