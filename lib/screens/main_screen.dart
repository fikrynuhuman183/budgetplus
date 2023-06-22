import 'package:flutter/material.dart';
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
  static const String title = 'BudgetPlus';

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 16),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: AppBar(
            backgroundColor: Color(0xFFF5F7FF),
            elevation: 0,
            leadingWidth: 120,
            leading: Hero(
              tag: 'tag',
              child: Image.asset('images/logo_no_text.png'),
            ),
            centerTitle: true,
            title: Text(
              MainPage.title,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              Container(
                padding: EdgeInsets.all(10),
                child: TextButton(
                  child: Text(
                    'Sign out',
                    style: TextStyle(
                      color: Color(0xFF4A44C6),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: BorderSide.none,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, MyApp.loginRoute, (route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration:
            Duration(milliseconds: 500), // Adjust the transition duration here
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
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }
}
