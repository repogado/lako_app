import 'package:flutter/material.dart';
import 'package:lako_app/models/settings.dart';
import 'package:lako_app/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class VendorSelectionScreen extends StatefulWidget {
  final String? id;
  final Function onBookTap;

  const VendorSelectionScreen({
    required this.id,
    required this.onBookTap,
    Key? key,
  }) : super(key: key);

  @override
  State<VendorSelectionScreen> createState() => _VendorSelectionScreenState();
}

class _VendorSelectionScreenState extends State<VendorSelectionScreen> {
  List<String> list = <String>[
    'All',
    'Fish Vendor',
    'Fruit Vendor',
    'Taho Vendor',
    'Mais Vendor',
    'Balut Vendor',
    'Ice Cream Vendor',
    'Maruya/Turon/kakanin Vendor',
  ];

  late SettingsProvider _settingsProvider;

  @override
  Widget build(BuildContext context) {
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("SELECT VENDOR"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          for (var i in list)
            ListTile(
              title: Text(i),
              tileColor:
                  _settingsProvider.settings.vendor == i ? Colors.amber : null,
              onTap: () {
                _settingsProvider.setVendor(i);
                widget.onBookTap(i);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
