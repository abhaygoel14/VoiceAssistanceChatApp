import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PiPCameraScreen extends StatefulWidget {
  const PiPCameraScreen({super.key});

  @override
  _PiPCameraScreenState createState() => _PiPCameraScreenState();
}

class _PiPCameraScreenState extends State<PiPCameraScreen> {
  CameraController? controller;
  bool _isReady = false;
  bool _hasError = false; // Track if there's an error
  String _errorMessage = ''; // Store error message

  @override
  void initState() {
    super.initState();
    _initializeFrontCamera();
  }

  Future<void> _initializeFrontCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => throw Exception('Front camera not available'),
      );

      controller = CameraController(
        frontCamera,
        ResolutionPreset.high, // High resolution for better quality
      );

      await controller!.initialize();
      if (mounted) { // Ensure widget is still mounted
        setState(() {
          _isReady = true;
          _hasError = false; // No error
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Error initializing camera: $e';
          debugPrint(_errorMessage); // Proper logging
        });
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
      );
    }

    if (!_isReady || controller == null || !controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FittedBox(
        fit: BoxFit.contain, // Use BoxFit.contain for a normal-sized view
        child: SizedBox(
          width: controller!.value.previewSize!.height*1.2,
          height: controller!.value.previewSize!.width*1.15, // Use correct dimensions for camera preview
          child: CameraPreview(controller!),
        ),
      ),
    );
  }
}
