import 'dart:typed_data' show Uint8List;

import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useListenable;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show
        ConsumerState,
        ConsumerStatefulWidget,
        ConsumerWidget,
        HookConsumerWidget,
        WidgetRef;
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
      preview: () => _Preview(
        notifier: ref.read(cameraLogicRef.notifier).controller,
      ),
      imageStream: (bytes) => _ImageStream(bytes: bytes),
    );
  }
}

class _Preview extends HookConsumerWidget {
  const _Preview({required this.notifier});

  final ValueNotifier<camera.CameraValue> notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useListenable(notifier);

    return camera.CameraPreview(
      notifier as camera.CameraController,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FloatingActionButton(
            onPressed: () async {
              final logic = ref.read(cameraLogicRef.notifier);
              if (logic.mounted) await logic.startImageStream();
            },
            child: const Icon(Icons.play_arrow_rounded),
          ),
        ),
      ),
    );
  }
}

class _ImageStream extends ConsumerWidget {
  const _ImageStream({required this.bytes});

  final Uint8List? bytes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        bytes != null
            ? Image.memory(bytes!, fit: BoxFit.contain)
            : const Center(
                child: Text('No data'),
              ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FloatingActionButton(
            onPressed: () async {
              final logic = ref.read(cameraLogicRef.notifier);
              if (logic.mounted) await logic.reset();
            },
            child: const Icon(Icons.stop_rounded),
          ),
        ),
      ],
    );
  }
}
