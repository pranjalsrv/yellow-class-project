import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_util/responsive_util.dart';

class CamerViewWidget extends StatefulWidget {
  @override
  _CamerViewWidgetState createState() => _CamerViewWidgetState();
}

class _CamerViewWidgetState extends State<CamerViewWidget> {
  CameraController _controller;
  List<CameraDescription> cameras;
  CameraDescription currentCamera;
  Future<void> _initializeControllerFuture;

  void _showCameraException(CameraException e) {
    Get.snackbar('Error: ${e.code}', '${e.description}');
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    // If the _controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        Get.snackbar('Camera error ', '${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(
      cameras[1],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) {
        print("Camera not mounted");
        return;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null
          ? _initializeControllerFuture = _controller.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  @override
  void dispose() {
    print('Camera disposed called');
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: CircularProgressIndicator());
          }
          return AspectRatio(aspectRatio: _controller.value.aspectRatio, child: CameraPreview(_controller));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
