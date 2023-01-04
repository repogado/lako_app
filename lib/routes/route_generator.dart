import 'package:flutter/material.dart';
import 'package:lako_app/models/vendorStoreArguments.dart';
import 'package:lako_app/screens/about_us/about_us.dart';
import 'package:lako_app/screens/auth/forgot_password.dart';
import 'package:lako_app/screens/auth/login.dart';
import 'package:lako_app/screens/auth/signup_customer.dart';
import 'package:lako_app/screens/auth/signup_vendor.dart';
import 'package:lako_app/screens/chat/chat.dart';
import 'package:lako_app/screens/contact_us/contact_us.dart';
import 'package:lako_app/screens/home/complete_setup.dart';
import 'package:lako_app/screens/home/home.dart';
import 'package:lako_app/screens/home/select_vendor.dart';
import 'package:lako_app/screens/home/vendor_home.dart';
import 'package:lako_app/screens/home/vendor_store.dart';
import 'package:lako_app/screens/notification/notification.dart';
import 'package:lako_app/screens/settings/my_account.dart';
import 'package:lako_app/screens/settings/settings.dart';
import 'package:lako_app/screens/spash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case '/signupvendor':
        return MaterialPageRoute(builder: (context) => SignupVendorScreen());
      case '/signupcustomer':
        return MaterialPageRoute(builder: (context) => SignupCustomer());
      case '/forgot_password':
        return MaterialPageRoute(builder: (context) => ForgotPassword());
      case '/complete_setup':
        return MaterialPageRoute(builder: (context) => CompleteSetup());
      case '/home':
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case '/vendor_selection':
        final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(
            builder: (context) => VendorSelectionScreen(
                  id: args.id,
                  onBookTap: args.onBookTap,
                ));
      case '/home_vendor':
        return MaterialPageRoute(builder: (context) => VendorHomeScreen());
      case '/vendor_store':
        final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(
            builder: (context) => VendorStore(
                  id: args.id,
                  onBookTap: args.onBookTap,
                ));
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
      case '/myaccount':
        return MaterialPageRoute(builder: (context) => MyAccountScreen());
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
