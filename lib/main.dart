import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lazy_camera/app.dart';

List<CameraDescription> cameras = <CameraDescription>[];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fetch the available cameras before initializing the app.
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('====> $e');
  }

  runApp(const App());
}
