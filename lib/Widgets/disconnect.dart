import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zaki_movie_apps/Services/consts.dart';

class Disconnect extends StatelessWidget {
  const Disconnect({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: background_primary,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.2,
          ),
          Center(
            child: Lottie.asset(
              "assets/disconnect.json",
              width: size.width * 0.8,
              // frameRate: FrameRate(60),
            ),
          ),
          Text(
            'youre diconnected',
            style: TextStyle(fontSize: 20, color: Colors.white),
          )
        ],
      ),
    );
  }
}
