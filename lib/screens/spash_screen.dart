import 'package:flutter/material.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/services/secure_storage_service.dart';
import 'package:lako_app/utils/size_config.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:lako_app/utils/globals.dart' as globals;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));

      Location location = Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      String? data = await SecureStorageService().readData('auth');
      if (data == null) {
        Navigator.of(context).pushNamed('/login');
      } else {
        _authProvider = Provider.of<AuthProvider>(context, listen: false);
        String token = _authProvider.setUser(data);
        globals.token = token;

        //check permission

        if (_authProvider.user.type == null ||
            _authProvider.user.type!.isEmpty) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/complete_setup', (Route<dynamic> routes) => false);
        } else {
          if (_authProvider.user.type == 'vendor') {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home_vendor', (Route<dynamic> routes) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> routes) => false);
          }
        }
      }

      // SelectionDialog.showSelectionDialog(context, (Choices choice) {
      //   log(choice.toString());
      // }, (val) {
      //   Navigator.of(context).pushNamed('/login');
      //   log(val.toString());
      // });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/logo.jpg"),
      ),
    );
  }
}
