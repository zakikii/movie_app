import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zaki_movie_apps/Services/consts.dart';

class Disconnected extends StatelessWidget {
  const Disconnected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: Container(
      height: size.height,
      width: size.width,
      color: background_primary,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.18,
          ),
          Center(
            child: Lottie.asset(
              "assets/disconnect.json",
              width: size.width * 0.8,
              // frameRate: FrameRate(60),
            ),
          ),
          Text(
            'youre disconnected',
            style: TextStyle(color: Colors.white, fontSize: 20),
          )
        ],
      ),
    )));
  }
}
