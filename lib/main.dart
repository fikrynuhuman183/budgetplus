import 'package:flutter/material.dart';
import 'screens/userpage.dart';
import 'screens/homepage.dart';
import 'screens/statisticspage.dart';
import 'screens/expensepage.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/main_screen.dart';
import 'package:budgetplus/components/add_expense_cat.dart';
import 'components/add_income_cat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String homeRoute = '/';
  static const String mainRoute = '/mainPage';
  static const String loginRoute = '/student-login';
  static const String registrationRoute = '/registration';
  static const String addExpCat = '/addExpenseCategory';
  static const String addIncCat = '/addIncomeCategory';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: homeRoute,
      routes: {
        homeRoute: (context) => HomePage(),
        mainRoute: (context) => MainPage(),
        registrationRoute: (context) => RegisterPage(),
        loginRoute: (context) => LoginPage(),
        addExpCat: (context) => AddExpenseCategory(),
        addIncCat: (context) => AddIncomeCategory(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case homeRoute:
            return SlideTransitionRoute(
              builder: (_) => HomePage(),
              direction: AxisDirection.right,
            );
          case loginRoute:
            return SlideTransitionRoute(
              builder: (_) => LoginPage(),
              direction: AxisDirection.left,
            );
          default:
            return null;
        }
      },
    );
  }
}

class SlideTransitionRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  final AxisDirection direction;

  SlideTransitionRoute({
    required this.builder,
    required this.direction,
  }) : super(
          pageBuilder: (_, __, ___) => builder(_),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(
                  direction == AxisDirection.left ? 1.0 : -1.0,
                  0.0,
                ),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
