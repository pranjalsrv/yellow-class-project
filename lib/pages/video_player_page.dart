import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:yellow_class_project/widgets/camera_view_widget.dart';
import 'package:yellow_class_project/widgets/volume_control_slider.dart';

class VideoPlayerPage extends StatefulWidget {
  static String routeName = '/video_player_page';

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  QueryDocumentSnapshot video = Get.arguments;
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  double xPosition = Get.mediaQuery.size.width * 0.5;
  double yPosition = Get.mediaQuery.size.height * 0.6;

  Future<void> initPlayer() async {
    videoPlayerController = VideoPlayerController.network(video['link']);
    await videoPlayerController.initialize();
    chewieController =
        ChewieController(videoPlayerController: videoPlayerController, autoPlay: true, looping: true,
            // fullScreenByDefault: true,
            deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ], deviceOrientationsOnEnterFullScreen: [
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: chewieController != null && chewieController.videoPlayerController.value.initialized
          ? OrientationBuilder(builder: (context, orientation) {
              if (orientation == Orientation.landscape && yPosition > Get.mediaQuery.size.height) {
                yPosition = 0;
              }

              if (orientation == Orientation.portrait && xPosition > Get.mediaQuery.size.width) {
                xPosition = 0;
              }
              // print(Get.mediaQuery.orientation.index);
              return Stack(
                children: [
                  Chewie(
                    controller: chewieController,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: VolumeControlSlider(),
                  ),
                  Positioned(
                    top: yPosition,
                    left: xPosition,
                    child: GestureDetector(
                        onPanUpdate: (tapInfo) {
                          setState(() {
                            xPosition += tapInfo.delta.dx;
                            yPosition += tapInfo.delta.dy;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(30),
                            width: orientation == Orientation.landscape
                                ? Get.mediaQuery.size.width * 0.3
                                : Get.mediaQuery.size.width * 0.5,
                            child: Transform(
                                alignment: FractionalOffset.center, // set transform origin
                                transform: orientation == Orientation.landscape
                                    ? Matrix4.rotationZ(-3.1415 / 2)
                                    : Matrix4.rotationZ(0),
                                child: CamerViewWidget()))),
                  )
                ],
              );
            })
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading'),
                ],
              ),
            ),
    );
  }
}
