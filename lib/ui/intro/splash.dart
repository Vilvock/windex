import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windex/res/assets.dart';

import '../../config/preferences.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      await Preferences.init();

      // if (await Preferences.getLogin()) {
      //   Navigator.pushReplacementNamed(context, '/ui/home');
      // } else {
      //   Navigator.pushReplacementNamed(context, '/ui/onboarding');
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: OwnerColors.colorAccent,
      child: Stack(fit: StackFit.expand, children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.splash,
              height: 250,
            ),
            SizedBox(height: 120)
          ],
        )
      ]),
    ));
  }
}
