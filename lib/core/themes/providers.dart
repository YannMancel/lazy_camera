import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Provider;
import 'package:lazy_camera/_features.dart';

/// Allows to retrieve [ThemeData].
final themeRef = Provider<ThemeData>(
  (_) => AppTheme.dark,
  name: 'themeRef',
);
