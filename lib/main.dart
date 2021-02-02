import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_geofence/geofence.dart';

import 'toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Android';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    Geofence.initialize();
    Geofence.startListening(GeolocationEvent.entry, (entry) {
      showToast('Masuk', Colors.green);
    });

    Geofence.startListening(GeolocationEvent.exit, (entry) {
      showToast('Keluar', Colors.red);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            RaisedButton(
              child: Text("Add region"),
              onPressed: () {
                Geolocation location = Geolocation(
                    latitude: -8.6674746,
                    longitude: 115.1965761,
                    radius: 8,
                    id: "Kerkplein13");
                Geofence.addGeolocation(location, GeolocationEvent.entry)
                    .then((onValue) {
                  showToast('add location', Colors.green);
                  print("great success");
                }).catchError((onError) {
                  print("great failure");
                });
              },
            ),
            RaisedButton(
              child: Text("Request Permissions"),
              onPressed: () {
                Geofence.requestPermissions();
              },
            ),
            RaisedButton(
                child: Text("get user location"),
                onPressed: () {
                  Geofence.getCurrentLocation().then((coordinate) {
                    print(
                        "great got latitude: ${coordinate.latitude} and longitude: ${coordinate.longitude}");
                  });
                })
          ],
        ),
      ),
    );
  }
}
