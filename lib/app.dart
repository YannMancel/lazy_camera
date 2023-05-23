import 'package:flutter/material.dart';
import 'package:lazy_camera/_features.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const kAppName = 'Lazy camera';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(title: kAppName),
    );
  }
}
