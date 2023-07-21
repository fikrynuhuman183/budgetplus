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
import 'components/auth_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static const String homeRoute = '/';
  static const String mainRoute = '/mainPage';
  static const String loginRoute = '/student-login';
  static const String registrationRoute = '/registration';
  static const String addExpCat = '/addExpenseCategory';
  static const String addIncCat = '/addIncomeCategory';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthHelper _authHelper = AuthHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAutoLogin();
  }

  void _checkAutoLogin() async {
    bool isLoggedIn = await _authHelper.autoLogin();
    if (isLoggedIn) {
      // User is already logged in, navigate to the home page
      Navigator.pushNamedAndRemoveUntil(context, MyApp.mainRoute,
          (route) => false); // Replace with your home page route
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: MyApp.homeRoute,
      routes: {
        MyApp.homeRoute: (context) => HomePage(),
        MyApp.mainRoute: (context) => MainPage(),
        MyApp.registrationRoute: (context) => RegisterPage(),
        MyApp.loginRoute: (context) => LoginPage(),
        MyApp.addExpCat: (context) => AddExpenseCategory(),
        MyApp.addIncCat: (context) => AddIncomeCategory(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case MyApp.homeRoute:
            return SlideTransitionRoute(
              builder: (_) => HomePage(),
              direction: AxisDirection.right,
            );
          case MyApp.loginRoute:
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
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve:
                      Curves.easeInOut, // Adjust the animation curve if needed
                  reverseCurve:
                      Curves.easeInOut, // Adjust the reverse curve if needed
                ),
              ),
              child: child,
            );
          },
        );
}
