import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:machine_test_lilac/Controller/home_controller.dart';
import 'package:machine_test_lilac/View/drawer/drawer.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    super.initState();
  }

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("video")),
        drawer: DrawerScreen(),
        body: GetBuilder<HomeController>(
          builder: (controller) => Center(
            child: controller.isLoading.value == false
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(
                        aspectRatio:
                            controller.controller.value!.value.aspectRatio,
                        child: VideoPlayer(controller.controller.value!),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VideoProgressIndicator(
                              controller.controller.value!,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: Colors.red,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.controller.value!
                                        .seekTo(Duration.zero);
                                  },
                                  icon: Icon(Icons.skip_previous),
                                ),
                                IconButton(
                                  onPressed: () {
                                    final position = controller
                                        .controller.value!.value.position;
                                    controller.controller.value!.seekTo(
                                        position - Duration(seconds: 10));
                                  },
                                  icon: Icon(Icons.fast_rewind),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.controller.value!.value.isPlaying
                                        ? controller.controller.value!.pause()
                                        : controller.controller.value!.play();
                                    setState(() {});
                                  },
                                  icon: Icon(controller
                                          .controller.value!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                ),
                                IconButton(
                                  onPressed: () {
                                    final position = controller
                                        .controller.value!.value.position;
                                    controller.controller.value!.seekTo(
                                        position + Duration(seconds: 10));
                                  },
                                  icon: Icon(Icons.fast_forward),
                                ),
                                IconButton(
                                  onPressed: () {
                                    final duration = controller
                                        .controller.value!.value.duration;
                                    controller.controller.value!
                                        .seekTo(duration!);
                                  },
                                  icon: Icon(Icons.skip_next),
                                ),
                                IconButton(
                                    onPressed: () {
                                      controller.downloadAndDecryptFile();
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (context) => AlertDialog(
                                      //     content: Obx(() =>
                                      Center(
                                        child: controller.downloading.value
                                            ? Container(
                                                height: 120.0,
                                                width: 200.0,
                                                child: Card(
                                                  color: Colors.black,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      CircularProgressIndicator(),
                                                      SizedBox(
                                                        height: 20.0,
                                                      ),
                                                      Text(
                                                        "Downloading File: ${controller.progressString}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Text("No Data"),
                                        // )),
                                        // ),
                                      );
                                    },
                                    icon: Icon(Icons.download_outlined))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : CircularProgressIndicator(), // Show a loader while video is loading
          ),
        ));
  }

  @override
  void dispose() async {
    controller.controller.value?.dispose();

    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    super.dispose();
  }
}
