import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:yellow_class_project/widgets/camera_view_widget.dart';

class VideoPlayerPage extends StatefulWidget {
  static String routeName = '/video_player_page';

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  QueryDocumentSnapshot video = Get.arguments;
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  double xPosition = 0;
  double yPosition = 0;

  Future<void> initPlayer() async {
    videoPlayerController = VideoPlayerController.network(video['link']);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      // fullScreenByDefault: true,
      // deviceOrientationsAfterFullScreen: [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight,],
      // deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
    );
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
      body: chewieController != null && chewieController.videoPlayerController.value.initialized
          ? Stack(
              children: [
                Chewie(
                  controller: chewieController,
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
                        width: Get.mediaQuery.size.width * 0.5,
                        height: Get.mediaQuery.size.height * 0.4,
                        child: CamerViewWidget()),
                  ),
                )
              ],
            )
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
