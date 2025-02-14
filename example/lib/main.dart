// ignore_for_file: deprecated_member_use

import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int batchIconNumber = 0;

  String currentIconName = "?";

  bool loading = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    DynamicIconFlutter.getAlternateIconName().then((v) {
      setState(() {
        currentIconName = v ?? "`primary`";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Dynamic App Icon'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 28),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Current Icon Name: $currentIconName",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.ac_unit),
                label: const Text("Team Fortress"),
                onPressed: () async {
                  try {
                    //print(await DynamicIconFlutter.supportsAlternateIcons);
                    if (await DynamicIconFlutter.supportsAlternateIcons) {
                      await DynamicIconFlutter.setAlternateIconName(
                          "teamfortress");
                      _scaffoldKey.currentState?.hideCurrentSnackBar();
                      _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                        content: Text("App icon change successful"),
                      ));
                      DynamicIconFlutter.getAlternateIconName().then((v) {
                        setState(() {
                          currentIconName = v ?? "`primary`";
                        });
                      });
                      return;
                    }
                  } on PlatformException {
                    // ignore: avoid_print
                    _scaffoldKey.currentState?.hideCurrentSnackBar();
                    _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                      content: Text("Failed to change app icon"),
                    ));
                  }
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.ac_unit),
                label: const Text("Photos"),
                onPressed: () async {
                  try {
                    if (await DynamicIconFlutter.supportsAlternateIcons) {
                      await DynamicIconFlutter.setAlternateIconName("photos");
                      _scaffoldKey.currentState?.hideCurrentSnackBar();
                      _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                        content: Text("App icon change successful"),
                      ));
                      DynamicIconFlutter.getAlternateIconName().then((v) {
                        setState(() {
                          currentIconName = v ?? "`primary`";
                        });
                      });
                      return;
                    }
                  } on PlatformException {
                    _scaffoldKey.currentState?.hideCurrentSnackBar();
                    _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                      content: Text("Failed to change app icon"),
                    ));
                  }
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.ac_unit),
                label: const Text("Chills"),
                onPressed: () async {
                  try {
                    if (await DynamicIconFlutter.supportsAlternateIcons) {
                      await DynamicIconFlutter.setAlternateIconName("chills");
                      _scaffoldKey.currentState?.hideCurrentSnackBar();
                      _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                        content: Text("App icon change successful"),
                      ));
                      DynamicIconFlutter.getAlternateIconName().then((v) {
                        setState(() {
                          currentIconName = v ?? "`primary`";
                        });
                      });
                      return;
                    }
                  } on PlatformException {
                    _scaffoldKey.currentState?.hideCurrentSnackBar();
                    _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                      content: Text("Failed to change app icon"),
                    ));
                  }
                },
              ),
              const SizedBox(
                height: 28,
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.restore_outlined),
                label: const Text("Restore Icon"),
                onPressed: () async {
                  try {
                    if (await DynamicIconFlutter.supportsAlternateIcons) {
                      await DynamicIconFlutter.setAlternateIconName(null);
                      _scaffoldKey.currentState?.hideCurrentSnackBar();
                      _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                        content: Text("App icon restore successful"),
                      ));
                      DynamicIconFlutter.getAlternateIconName().then((v) {
                        setState(() {
                          currentIconName = v ?? "`primary`";
                        });
                      });
                      return;
                    }
                  } on PlatformException {
                    _scaffoldKey.currentState?.hideCurrentSnackBar();
                    _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                      content: Text("Failed to change app icon"),
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
