import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  bool isPlaying = false;
  double value = 0;

  final player = AudioPlayer();
  Duration? duration = const Duration(seconds: 0);

  void initPlayer() async {
    await player.setSource(AssetSource("tajdarNaat.mpeg"));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/tajdarBg.jpg"),
                    fit: BoxFit.cover)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black12,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                          image: AssetImage("assets/tajdarCover.jpg"),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Tajdar - e - Haram",
                  style: TextStyle(
                      fontSize: 30, color: Colors.white, letterSpacing: 3),
                ),
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${(value / 60).floor()}:${(value % 60).floor()}",
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Slider(
                        min: 0.0,
                        max: duration!.inSeconds.toDouble(),
                        activeColor: Colors.white,
                        inactiveColor: const Color.fromARGB(255, 153, 153, 153),
                        value: value,
                        onChangeEnd: (newvalue) async {
                          setState(() {
                            value = newvalue;
                            if (kDebugMode) {
                              print(newvalue);
                            }
                          });
                          player.pause();
                          await player
                              .seek(Duration(seconds: newvalue.toInt()));
                          await player.resume();
                        },
                        onChanged: ((val) {
                          setState(() {
                            value = val;
                          });
                        })),
                    Text(
                      "${duration!.inMinutes}:${duration!.inSeconds % 60}",
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 159, 22, 12),
                          width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await player.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            await player.resume();
                            setState(() {
                              isPlaying = true;
                            });
                            player.onPositionChanged.listen((position) {
                              setState(() {
                                value = position.inSeconds.toDouble();
                                
                              });
                            });
                          }
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
