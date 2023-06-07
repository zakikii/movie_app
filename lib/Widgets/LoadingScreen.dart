import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zaki_movie_apps/Services/consts.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: background_primary,
      child: Center(
        child: Lottie.asset(
          "assets/RDR.json",
          width: size.width * 0.8,
          // frameRate: FrameRate(60),
        ),
      ),
    );
  }
}
