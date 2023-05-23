import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lazy_camera/app.dart';
import 'package:lazy_camera/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  CameraController? _controller;

  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    final cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
    );

    _controller = cameraController;

    cameraController.addListener(() {
      if (mounted) setState(() {});

      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          print('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          print('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          print('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          print('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          print('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          print('Audio access is restricted.');
          break;
        default:
          print(e);
          break;
      }
    }

    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final selectedCameras = cameras
        .where((camera) => camera.lensDirection == CameraLensDirection.front);

    _initializeCameraController(selectedCameras.firstOrNull ?? cameras.first);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(App.kAppName),
      ),
      body: (_controller?.value.isInitialized ?? false)
          ? CameraPreview(
              _controller!,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.camera),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
