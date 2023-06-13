import 'package:flutter/material.dart';
import 'homepage.dart';
import 'userpage.dart';
import 'incomepage.dart';
import 'statisticspage.dart';
import 'expensepage.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budgetplus/main.dart';
import 'package:animations/animations.dart';


class MainPage extends StatefulWidget {
  static const String title = 'Expense Tracker';

  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  final List<Widget> _pages = [
    ExpensesPage(),
    IncomePage(),
    StatisticsPage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MainPage.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F7FF),
          elevation: 0,
          centerTitle: true,
          title: Text(
            MainPage.title,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 500), // Adjust the transition duration here
          transitionBuilder: (Widget child, Animation<double> animation) {
            final int pageIndex = _pages.indexOf(child);
            final bool slideFromRight = pageIndex > _previousIndex;
            final bool slideToLeft = pageIndex < _previousIndex;

            if (slideFromRight) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            } else if (slideToLeft) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            } else {
              return child;
            }
          },
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.money_off),
              label: 'Expenses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Income',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'User',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xFF4A44C6),
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }
}







