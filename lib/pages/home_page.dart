import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yellow_class_project/controllers/user_controller.dart';
import 'package:yellow_class_project/pages/video_player_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController userController = UserController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Videos",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('videos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Hey ${userController.user.name ?? "Nameless"},",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Select a video you'd like to view.",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "You can add videos in this list from the Firebase Console.",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 50,),
                  Column(
                    children: snapshot.data.docs
                        .map((video) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              child: OutlineButton(
                                  highlightColor: Theme.of(context).accentColor,
                                  highlightedBorderColor: Theme.of(context).accentColor,
                                  onPressed: () {
                                    Get.toNamed(VideoPlayerPage.routeName, arguments: video);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(video['title']),
                                      ],
                                    ),
                                  )),
                            ))
                        .toList(),
                  ),
                ],
              ),
            );
            // return Column(children: [Text(snapshot.data.documents.toString())],);
          } else if (snapshot.hasError) {
            return Text("Something Went Wrong");
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
