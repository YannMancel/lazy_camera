import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Consumer, ConsumerState, ConsumerStatefulWidget;
import 'package:lazy_camera/_features.dart';

class CameraPreview extends ConsumerStatefulWidget with WidgetsBindingObserver {
  const CameraPreview({super.key});

  @override
  ConsumerState<CameraPreview> createState() => _CameraPreviewState();
}

class _CameraPreviewState extends ConsumerState<CameraPreview>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final logic = ref.read(cameraLogicRef.notifier);
    if (!logic.mounted) return;

    switch (state) {
      case AppLifecycleState.resumed:
        logic.reset();
      case AppLifecycleState.inactive:
        logic.onDispose();
      default: // Do nothing here
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraLogicRef);

    return cameraState.when<Widget>(
      uninitialized: () => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      initialized: () {
        final cameraController =
            ref.read(cameraControllerNotifierRef) as camera.CameraController;

        return Consumer(
          builder: (_, ref, child) {
            ref.watch(cameraControllerNotifierRef);

            return camera.CameraPreview(
              cameraController,
              child: child,
            );
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  //TODO add callback
                },
                child: const Icon(Icons.play_arrow_rounded),
              ),
            ),
          ),
        );
      },
    );
  }
}
