import 'package:camera/camera.dart';

class CameraUtility {
  static Future<CameraController> initializeController(
    // List<CameraDescription> cameras,
    CameraDescription camera,
  ) async {
    CameraController controller = CameraController(
      camera,
      ResolutionPreset.veryHigh,
      enableAudio: true,
    );

    await controller.initialize();
    await controller.prepareForVideoRecording();

    return controller;
  }
}
