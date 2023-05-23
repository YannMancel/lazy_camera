import 'package:flutter/material.dart';
import 'package:lazy_camera/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const kAppName = 'Lazy camera';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
