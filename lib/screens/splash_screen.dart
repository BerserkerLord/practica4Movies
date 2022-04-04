import 'package:flutter/material.dart';
import 'package:practica2/screens/login.dart';
import 'package:practica2/settings/settings_color.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: Login(),
      duration: 3000,
      imageSize: 130,
      imageSrc: "assets/logoitc.png",
      text: "Bienvenidos Linces :)",
      textType: TextType.ScaleAnimatedText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: SettingsColor.backColor,
    );
  }
}
