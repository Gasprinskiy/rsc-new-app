import 'package:flutter/material.dart';
import 'package:test_flutter/routes/main/children/accounting.dart';
import 'package:test_flutter/routes/main/children/home.dart';
import 'package:test_flutter/routes/main/children/user.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int _selectedViewIndex = 0;

  static const List<Widget> viewOptions = [
    Home(),
    Accounting(),
    User(),
  ];

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _selectedViewIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: viewOptions.elementAt(_selectedViewIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Отчет',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_sharp),
            label: 'Польователь',
          ),
        ],
        currentIndex: _selectedViewIndex,
        selectedItemColor: Colors.green[300],
        onTap: _onBottomBarItemTapped,
      ),
    );
  }
}
