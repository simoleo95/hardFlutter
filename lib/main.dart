import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'takePicture.dart';
import 'bluetooth.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      home: FirstRoute(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

class FirstRoute extends StatelessWidget {
  final CameraDescription camera;

  const FirstRoute({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    String indirizzo;
    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      indirizzo = 'position ' +
          position.latitude.toString() +
          ', ' +
          position.longitude.toString();
      print(indirizzo);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            child: Text('Open camera'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TakePictureScreen(
                          camera: camera,
                        )),
              );
            },
          ),
          RaisedButton(
            child: Text('Geolocalizz'),
            onPressed: () {
              print(indirizzo);
            },
          ),
          RaisedButton(
            child: Text('Bluetooth'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bluetooth()),
              );
            },
          ),
        ],
      )),
    );
  }
}
