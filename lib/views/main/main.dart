import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/state/user.dart';
import 'package:test_flutter/views/main/children/accounting.dart';
import 'package:test_flutter/views/main/children/home.dart';
import 'package:test_flutter/views/main/children/user.dart';

class MainRoute extends StatefulWidget {
  
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int _selectedViewIndex = 2;
  final userState = UserState.getInstance();

  static const List<Widget> viewOptions = [
    Home(),
    Accounting(),
    UserRoute(),
  ];

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _selectedViewIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
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
        selectedItemColor: AppColors.primary,
        onTap: _onBottomBarItemTapped,
      ),
    );
  }
}
