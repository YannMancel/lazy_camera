import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:lazy_camera/_features.dart';

class App extends ConsumerWidget {
  const App({super.key});

  static const kAppName = 'Lazy camera';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeRef);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      theme: theme,
      home: const HomePage(title: kAppName),
    );
  }
}
