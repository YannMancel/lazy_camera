import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ProviderObserver, ProviderScope;
import 'package:lazy_camera/app.dart';

import '_features.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      observers: kDebugMode ? <ProviderObserver>[AppObserver()] : null,
      child: App(),
    ),
  );
}
