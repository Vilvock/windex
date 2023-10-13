import 'dart:async';

import 'package:flutter/material.dart';
import 'package:windex/res/assets.dart';

import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../auth/login/login.dart';
import '../components/dot_indicator.dart';
import '../components/gradient_text.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController _pageController;
  int _pageIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: OwnerColors.colorAccent,
        child: Stack(
          children: [
            Container(
                child: PageView.builder(
                    itemCount: demo_data.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) => OnboardingContent(
                          image: demo_data[index].image,
                          title: demo_data[index].title,
                          subtitle: demo_data[index].subtitle,
                          pos: demo_data[index].pos,
                        ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.all(Dimens.paddingApplication),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                            demo_data.length,
                            (index) => DotIndicator(
                              isActive: index == _pageIndex,
                              color: OwnerColors.colorPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Dimens.marginApplication),
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: Styles().styleDefaultButton,
                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                                ModalRoute.withName("/ui/login"));
                          },
                          child: Text("Permitir",
                              style: Styles().styleDefaultTextButton),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class Onboard {
  final String image, title, subtitle;
  final int pos;

  const Onboard(
      {required this.title,
      required this.image,
      required this.subtitle,
      required this.pos});
}

final List<Onboard> demo_data = [
  Onboard(
      image: Assets.intro1,
      title: "Conheça novas pessoas",
      subtitle: Strings.shortLoremIpsum,
      pos: 0),
  Onboard(
      image: Assets.intro2,
      title: "Acessar\nLocalização",
      subtitle:
          "Para que o aplicativo funcione corretamente, precisamos acessar sua localização.",
      pos: 1),
  Onboard(
      image: Assets.intro3,
      title: "Permitir\nNotificações",
      subtitle:
          "Não perca atualizações do nosso aplicativo, permita acesso às suas notificações.",
      pos: 2),
];

class OnboardingContent extends StatelessWidget {
  final String image, title, subtitle;
  final int pos;

  const OnboardingContent(
      {Key? key,
      required this.title,
      required this.image,
      required this.subtitle,
      required this.pos});

  @override
  Widget build(BuildContext context) {
    if (pos == 0) {
      return Container(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(left:
              Dimens.paddingApplication, right: Dimens.paddingApplication
              ),
              child: Column(children: [
                GradientText(
                  align: TextAlign.start,
                  title,
                  style: TextStyle(
                      fontSize: Dimens.textSize11,
                      color: OwnerColors.colorPrimaryDark,
                      fontWeight: FontWeight.w900),
                  gradient: LinearGradient(colors: [
                    OwnerColors.gradientFirstColor,
                    OwnerColors.gradientSecondaryColor,
                    OwnerColors.gradientThirdColor
                  ]),
                ),
                SizedBox(
                  height: Dimens.marginApplication,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      fontSize: Dimens.textSize6,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      height: 1.5
                  ),
                  textAlign: TextAlign.start,
                ),
              ]),
            ),

          ]));
    } else {
      return Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          height: 30,
        ),
        Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 2,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 3.4,
            )),
        Padding(
          padding: EdgeInsets.only(left:
            Dimens.paddingApplication, right: Dimens.paddingApplication
          ),
          child: Column(children: [
            GradientText(
              align: TextAlign.center,
              title,
              style: TextStyle(
                  fontSize: Dimens.textSize10,
                  color: OwnerColors.colorPrimaryDark,
                  fontWeight: FontWeight.w900),
              gradient: LinearGradient(colors: [
                OwnerColors.gradientFirstColor,
                OwnerColors.gradientSecondaryColor,
                OwnerColors.gradientThirdColor
              ]),
            ),
            SizedBox(
              height: Dimens.marginApplication,
            ),
            Text(
              subtitle,
              style: TextStyle(
                  fontSize: Dimens.textSize6,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  height: 1.5
                  ),
              textAlign: TextAlign.center,
            ),
          ]),
        ),

      ]));
    }
  }
}
