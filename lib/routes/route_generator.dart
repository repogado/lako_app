import 'package:flutter/material.dart';
import 'package:lako_app/screens/about_us/about_us.dart';
import 'package:lako_app/screens/auth/login.dart';
import 'package:lako_app/screens/auth/signup_customer.dart';
import 'package:lako_app/screens/auth/signup_vendor.dart';
import 'package:lako_app/screens/chat/chat.dart';
import 'package:lako_app/screens/contact_us/contact_us.dart';
import 'package:lako_app/screens/home/home.dart';
import 'package:lako_app/screens/notification/notification.dart';
import 'package:lako_app/screens/settings/settings.dart';
import 'package:lako_app/screens/spash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case '/signupvendor':
        return MaterialPageRoute(builder: (context) => SignupVendorScreen());
      case '/signupcustomer':
        return MaterialPageRoute(builder: (context) => SignupCustomer());
      case '/home':
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case '/chat':
        return MaterialPageRoute(builder: (context) => ChatScreen());
      case '/notification':
        return MaterialPageRoute(builder: (context) => NotificationScreen());
      case '/contact_us':
        return MaterialPageRoute(builder: (context) => ContactUsScreen());
      case '/about_us':
        return MaterialPageRoute(builder: (context) => AboutUsScreen());
      case '/settings':
        return MaterialPageRoute(builder: (context) => SettingsScreen());
      default:
        return _errorRoute();
    }
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
        centerTitle: true,
      ),
      body: Center(child: Text('Page not found')),
    );
  });
}
