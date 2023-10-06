import 'dart:async';

import 'package:flutter/material.dart';

import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../auth/login/login.dart';
import '../components/dot_indicator.dart';

// VAI NA LINHA 68
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
                        ))),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  margin: EdgeInsets.only(top: 50, right: 26),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            ModalRoute.withName("/ui/login"));
                      },
                      child: Text(
                        "Pular".toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ))),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: Dimens.paddingApplication),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      demo_data.length,
                      (index) => DotIndicator(
                        isActive: index == _pageIndex,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Onboard {
  final String image, title, subtitle;

  const Onboard(
      {required this.title, required this.image, required this.subtitle});
}

final List<Onboard> demo_data = [
  Onboard(
    image: 'images/slide1.png',
    title: "BEM VINDO A SAFETY GLASSES",
    subtitle:
        "FÁBRICA DE ÓCULOS DE SEGURANÇA COM MAIS DE 12 ANOS DE ATUAÇÃO NÓS PROTEGEMOS SUA EMPRESA E SEUS COLABORADORES!",
  ),
  Onboard(
    image: 'images/slide2.png',
    title: "SAFETY APP ÓCULOS COM AGILIDADE",
    subtitle:
        "COM O APP VOCÊ PASSA A TER SEUS ÓCULOS DE SEGURANÇA COM GRAU, DE FORMA RÁPIDA E ÁGIL. A QUALIDADE, BELEZA E CONFORTO NA PALMA DA MÃO.",
  ),
  Onboard(
    image: 'images/slide3.png',
    title: "FÁCIL DE PEDIR, RÁPIDO EM CHEGAR",
    subtitle:
        "AQUI VOCÊ VAI ESCOLHER SEUS ÓCULOS DE SEGURANÇA EM 3 ETAPAS: ARMAÇÃO, DEPOIS LENTE E ENVIO DE FOTO E RECEITA",
  ),
];

class OnboardingContent extends StatelessWidget {
  final String image, title, subtitle;

  const OnboardingContent(
      {Key? key,
      required this.title,
      required this.image,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand,
      children: [
        Image.asset(
          image,
          fit: BoxFit.cover,
        ),
        Container(
            margin: EdgeInsets.all(30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column( mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Styles().styleTitleText,
                      textAlign: TextAlign.center,
                    ),
                   SizedBox(height: Dimens.marginApplication,),
                   Text(
                        subtitle,
                        style: Styles().styleDescriptionText,
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: 60,),

                  ]),
            ))
      ],
    );
  }
}
