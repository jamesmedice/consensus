import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPreviewWidget extends StatelessWidget {
  final Future<void> initializeControllerFuture;
  final CameraController controller;

  CameraPreviewWidget({
    required this.initializeControllerFuture,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(controller);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
