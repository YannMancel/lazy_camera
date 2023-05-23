import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show AsyncValueX, ConsumerWidget, WidgetRef;
import 'package:lazy_camera/_features.dart';

class CamerasBuilder extends ConsumerWidget {
  const CamerasBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext, List<camera.CameraDescription>) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableCamerasAsync = ref.watch(availableCamerasRef);

    return availableCamerasAsync.when<Widget>(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, _) => Center(
        child: Text(err.toString()),
      ),
      data: (data) => builder(context, data),
    );
  }
}
