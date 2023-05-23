import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Consumer;
import 'package:lazy_camera/_features.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Consumer(
        builder: (context, ref, __) {
          ref.listen<AppException?>(
            appExceptionRef,
            (_, next) {
              if (next != null) context.notify = next.toLabel;
            },
          );

          return const CameraPreview();
        },
      ),
    );
  }
}
