import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:windex/ui/components/alert_dialog_windex.dart';

import '../../../config/preferences.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/assets.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/strings.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';
import '../../components/dot_indicator.dart';
import '../../components/gradient_text.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetails();
}

class _EventDetails extends State<EventDetails> {
  late PageController _pageController;
  int _pageIndex = 0;

  final postRequest = PostRequest();
  User? _profileResponse;

  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
            title: "Detalhes do Evento",
            isVisibleBackButton: true,
            isNotVisibleLine: true),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                child: ClipRRect(
                    child: Image.network(
                  Assets.generic_party,
                  fit: BoxFit.fitWidth,
                  height: 220,
                  errorBuilder: (context, exception, stackTrack) => Image.asset(
                    fit: BoxFit.fitWidth,
                    Assets.generic_party,
                    height: 220,
                  ),
                ))),
            Container(
              padding: EdgeInsets.all(Dimens.paddingApplication),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Computaria unificada",
                      style: TextStyle(
                          fontSize: Dimens.textSize9,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: Dimens.marginApplication,
                    ),
                    SizedBox(
                      height: Dimens.minMarginApplication,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(right: 14),
                          child: Image.asset(Assets.calendar_gold, scale: 1.4),
                          decoration: BoxDecoration(
                            color: OwnerColors.darkGrey2,
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.minRadiusApplication)),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "14 December, 2021",
                                style: TextStyle(
                                  fontSize: Dimens.textSize6,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: Dimens.minMarginApplication),
                              Text(
                                "Quarta, 19h30 - 23h00",
                                style: TextStyle(
                                    fontSize: Dimens.textSize4,
                                    color: Colors.white70,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w200),
                              ),
                              SizedBox(height: Dimens.minMarginApplication),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimens.marginApplication,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(right: 14),
                          child: Image.asset(Assets.location_gold, scale: 1.4),
                          decoration: BoxDecoration(
                            color: OwnerColors.darkGrey2,
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.minRadiusApplication)),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Calourada unificada",
                                style: TextStyle(
                                  fontSize: Dimens.textSize6,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: Dimens.minMarginApplication),
                              Text(
                                "Casa da vovó (13km)",
                                style: TextStyle(
                                    fontSize: Dimens.textSize4,
                                    color: Colors.white70,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w200),
                              ),
                              SizedBox(height: Dimens.minMarginApplication),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimens.marginApplication,
                    ),
                    Container(
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.radiusApplication),
                            ),
                            child: Image.network(
                              Assets.generic_maps,
                              fit: BoxFit.fitWidth,
                              height: 160,
                              errorBuilder: (context, exception, stackTrack) =>
                                  Image.asset(
                                fit: BoxFit.fitWidth,
                                Assets.generic_maps,
                                height: 160,
                              ),
                            ))),
                    SizedBox(
                      height: Dimens.minMarginApplication,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: Dimens.marginApplication),
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: Styles().styleDefaultButton,
                        onPressed: () async {
                          showModalBottomSheet<dynamic>(
                              isScrollControlled: true,
                              context: context,
                              shape: Styles().styleShapeBottomSheet,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (BuildContext context) {
                                return WindexPremiumAlertDialog();
                              });
                        },
                        child: (_isLoading)
                            ? const SizedBox(
                                width: Dimens.buttonIndicatorWidth,
                                height: Dimens.buttonIndicatorHeight,
                                child: CircularProgressIndicator(
                                  color: OwnerColors.colorAccent,
                                  strokeWidth: Dimens.buttonIndicatorStrokes,
                                ))
                            : Text("Iníciar rota",
                                style: Styles().styleDefaultTextButton),
                      ),
                    ),
                    SizedBox(
                      height: Dimens.marginApplication,
                    ),
                    SizedBox(
                      height: Dimens.minMarginApplication,
                    ),
                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.only(bottom: Dimens.minMarginApplication),
                      child: Text(
                        "O que o lugar oferece",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: Dimens.textSize5,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimens.marginApplication,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.car_crash_outlined,
                          color: Colors.white70,
                          size: 20,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            Strings.littleLoremIpsum,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: Dimens.textSize4,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Dimens.marginApplication,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.private_connectivity_outlined,
                          color: Colors.white70,
                          size: 20,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            Strings.littleLoremIpsum,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: Dimens.textSize4,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),

                  ]),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(Dimens.marginApplication),
              child: Text(
                "Eventos similares",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: Dimens.textSize5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(
              height: Dimens.marginApplication,
            ),
            Container(
                height: 192,
                child: PageView.builder(
                  itemCount: 3,
                  controller: _pageController,
                  // physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return InkWell(
                          onTap: () => {
                                Navigator.pushNamed(
                                    context, "/ui/event_details")
                              },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: Dimens.marginApplication,
                                  right: Dimens.marginApplication),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.2, color: Colors.white70),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.radiusApplication)),
                              ),
                              child: Container(
                                  child: SizedBox(
                                      height: 190,
                                      child: Row(
                                        children: [
                                          Container(
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          Dimens
                                                              .radiusApplication),
                                                      bottomLeft:
                                                          Radius.circular(Dimens
                                                              .radiusApplication)),
                                                  child: Image.network(
                                                    Assets.generic_party2,
                                                    fit: BoxFit.cover,
                                                    height: 190,
                                                    width: 120,
                                                    errorBuilder: (context,
                                                            exception,
                                                            stackTrack) =>
                                                        Image.asset(
                                                      fit: BoxFit.cover,
                                                      Assets.generic_party2,
                                                      height: 190,
                                                      width: 120,
                                                    ),
                                                  ))),
                                          Expanded(
                                              child: Padding(
                                                  padding: EdgeInsets.all(Dimens
                                                      .paddingApplication),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  "Quarta, 24 de abril ",
                                                              style: TextStyle(
                                                                  fontSize: Dimens
                                                                      .textSize4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: OwnerColors
                                                                      .colorPrimaryDark,
                                                                  wordSpacing:
                                                                      0.5),
                                                            ),
                                                            TextSpan(
                                                              text: '19:30',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: Dimens
                                                                      .textSize4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  wordSpacing:
                                                                      0.5),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: Dimens
                                                              .minMarginApplication),
                                                      Text(
                                                        "Computaria unificada",
                                                        style: TextStyle(
                                                            fontSize: Dimens
                                                                .textSize7,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      Text(
                                                        "Moc hall Festas",
                                                        style: TextStyle(
                                                            fontSize: Dimens
                                                                .textSize4,
                                                            color:
                                                                Colors.white70,
                                                            letterSpacing: 1,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w100),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: Dimens
                                                                .marginApplication),
                                                        height: 36,
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                          style: Styles()
                                                              .styleDefaultButton,
                                                          onPressed:
                                                              () async {},
                                                          child: (_isLoading)
                                                              ? const SizedBox(
                                                                  width: Dimens
                                                                      .buttonIndicatorWidth,
                                                                  height: Dimens
                                                                      .buttonIndicatorHeight,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: OwnerColors
                                                                        .colorAccent,
                                                                    strokeWidth:
                                                                        Dimens
                                                                            .buttonIndicatorStrokes,
                                                                  ))
                                                              : Text(
                                                                  "Ver evento",
                                                                  style: Styles()
                                                                      .styleDefaultTextButton2),
                                                        ),
                                                      ),
                                                    ],
                                                  )))
                                        ],
                                      )))));
                    } else if (index == 1) {
                      return InkWell(
                          onTap: () => {
                                Navigator.pushNamed(
                                    context, "/ui/event_details")
                              },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: Dimens.marginApplication,
                                  right: Dimens.marginApplication),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.2, color: Colors.white70),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.radiusApplication)),
                              ),
                              child: Container(
                                  child: SizedBox(
                                      height: 190,
                                      child: Row(
                                        children: [
                                          Container(
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          Dimens
                                                              .radiusApplication),
                                                      bottomLeft:
                                                          Radius.circular(Dimens
                                                              .radiusApplication)),
                                                  child: Image.network(
                                                    Assets.generic_party2,
                                                    fit: BoxFit.cover,
                                                    height: 190,
                                                    width: 120,
                                                    errorBuilder: (context,
                                                            exception,
                                                            stackTrack) =>
                                                        Image.asset(
                                                      fit: BoxFit.cover,
                                                      Assets.generic_party2,
                                                      height: 190,
                                                      width: 120,
                                                    ),
                                                  ))),
                                          Expanded(
                                              child: Padding(
                                                  padding: EdgeInsets.all(Dimens
                                                      .paddingApplication),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  "Quarta, 24 de abril ",
                                                              style: TextStyle(
                                                                  fontSize: Dimens
                                                                      .textSize4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: OwnerColors
                                                                      .colorPrimaryDark,
                                                                  wordSpacing:
                                                                      0.5),
                                                            ),
                                                            TextSpan(
                                                              text: '19:30',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: Dimens
                                                                      .textSize4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  wordSpacing:
                                                                      0.5),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: Dimens
                                                              .minMarginApplication),
                                                      Text(
                                                        "Computaria unificada",
                                                        style: TextStyle(
                                                            fontSize: Dimens
                                                                .textSize7,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      Text(
                                                        "Moc hall Festas",
                                                        style: TextStyle(
                                                            fontSize: Dimens
                                                                .textSize4,
                                                            color:
                                                                Colors.white70,
                                                            letterSpacing: 1,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w100),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: Dimens
                                                                .marginApplication),
                                                        height: 36,
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                          style: Styles()
                                                              .styleDefaultButton,
                                                          onPressed:
                                                              () async {},
                                                          child: (_isLoading)
                                                              ? const SizedBox(
                                                                  width: Dimens
                                                                      .buttonIndicatorWidth,
                                                                  height: Dimens
                                                                      .buttonIndicatorHeight,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: OwnerColors
                                                                        .colorAccent,
                                                                    strokeWidth:
                                                                        Dimens
                                                                            .buttonIndicatorStrokes,
                                                                  ))
                                                              : Text(
                                                                  "Ver evento",
                                                                  style: Styles()
                                                                      .styleDefaultTextButton2),
                                                        ),
                                                      ),
                                                    ],
                                                  )))
                                        ],
                                      )))));
                    } else {
                      return InkWell(
                          onTap: () => {
                                Navigator.pushNamed(
                                    context, "/ui/event_details")
                              },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: Dimens.marginApplication,
                                  right: Dimens.marginApplication),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.2, color: Colors.white70),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.radiusApplication)),
                              ),
                              child: Container(
                                  child: SizedBox(
                                      height: 190,
                                      child: Row(
                                        children: [
                                          Container(
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          Dimens
                                                              .radiusApplication),
                                                      bottomLeft:
                                                          Radius.circular(Dimens
                                                              .radiusApplication)),
                                                  child: Image.network(
                                                    Assets.generic_party2,
                                                    fit: BoxFit.cover,
                                                    height: 190,
                                                    width: 120,
                                                    errorBuilder: (context,
                                                            exception,
                                                            stackTrack) =>
                                                        Image.asset(
                                                      fit: BoxFit.cover,
                                                      Assets.generic_party2,
                                                      height: 190,
                                                      width: 120,
                                                    ),
                                                  ))),
                                          Expanded(
                                              child: Padding(
                                                  padding: EdgeInsets.all(Dimens
                                                      .paddingApplication),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  "Quarta, 24 de abril ",
                                                              style: TextStyle(
                                                                  fontSize: Dimens
                                                                      .textSize4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: OwnerColors
                                                                      .colorPrimaryDark,
                                                                  wordSpacing:
                                                                      0.5),
                                                            ),
                                                            TextSpan(
                                                              text: '19:30',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: Dimens
                                                                      .textSize4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  wordSpacing:
                                                                      0.5),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: Dimens
                                                              .minMarginApplication),
                                                      Text(
                                                        "Computaria unificada",
                                                        style: TextStyle(
                                                            fontSize: Dimens
                                                                .textSize7,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      Text(
                                                        "Moc hall Festas",
                                                        style: TextStyle(
                                                            fontSize: Dimens
                                                                .textSize4,
                                                            color:
                                                                Colors.white70,
                                                            letterSpacing: 1,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w100),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: Dimens
                                                                .marginApplication),
                                                        height: 36,
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                          style: Styles()
                                                              .styleDefaultButton,
                                                          onPressed:
                                                              () async {},
                                                          child: (_isLoading)
                                                              ? const SizedBox(
                                                                  width: Dimens
                                                                      .buttonIndicatorWidth,
                                                                  height: Dimens
                                                                      .buttonIndicatorHeight,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: OwnerColors
                                                                        .colorAccent,
                                                                    strokeWidth:
                                                                        Dimens
                                                                            .buttonIndicatorStrokes,
                                                                  ))
                                                              : Text(
                                                                  "Ver evento",
                                                                  style: Styles()
                                                                      .styleDefaultTextButton2),
                                                        ),
                                                      ),
                                                    ],
                                                  )))
                                        ],
                                      )))));
                    }
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  3,
                  (index) => DotIndicator(
                    isActive: index == _pageIndex,
                    color: OwnerColors.colorPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimens.marginApplication,
            ),
            SizedBox(
              height: Dimens.marginApplication,
            ),
          ],
        ))));
  }
}
