import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/application_messages.dart';
import '../../config/masks.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/assets.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../auth/login/login.dart';
import '../components/alert_dialog_generic.dart';
import '../components/custom_app_bar.dart';

class Plans extends StatefulWidget {
  const Plans({Key? key}) : super(key: key);

  @override
  State<Plans> createState() => _Plans();
}

class _Plans extends State<Plans> {
  final postRequest = PostRequest();

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
        appBar: CustomAppBar(title: "Planos", isVisibleBackButton: true),
        resizeToAvoidBottomInset: false,
        body: Container(
            child: CustomScrollView(slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(Dimens.paddingApplication),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Escolha um de nossos planos",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: Dimens.textSize5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
                Styles().div_horizontal,
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(Dimens.paddingApplication),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Básico",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: Dimens.textSize8,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8),
                        ),
                        SizedBox(
                          height: Dimens.marginApplication,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'R\$ ',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Dimens.textSize6,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.2),
                              ),
                              TextSpan(
                                  text: "90,00",
                                  style: TextStyle(
                                      fontSize: Dimens.textSize10,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.2)),
                              TextSpan(
                                text: '/mês',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Dimens.textSize6,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimens.marginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Dimens.marginApplication),
                          height: 42,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: Styles().styleDefaultButton,
                            onPressed: () async {

                              Navigator.pushNamed(context, "/ui/payments");
                            },
                            child: (_isLoading)
                                ? const SizedBox(
                                width: Dimens.buttonIndicatorWidth,
                                height: Dimens.buttonIndicatorHeight,
                                child: CircularProgressIndicator(
                                  color: OwnerColors.colorAccent,
                                  strokeWidth: Dimens.buttonIndicatorStrokes,
                                ))
                                :  Text("Escolher",
                                style: Styles().styleDefaultTextButton),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 12,),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(Dimens.paddingApplication),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Premium",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: Dimens.textSize8,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8),
                        ),
                        SizedBox(
                          height: Dimens.marginApplication,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'R\$ ',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Dimens.textSize6,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.2),
                              ),
                              TextSpan(
                                  text: "90,00",
                                  style: TextStyle(
                                      fontSize: Dimens.textSize10,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.2)),
                              TextSpan(
                                text: '/mês',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Dimens.textSize6,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimens.marginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Dimens.marginApplication),
                          height: 42,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: Styles().styleDefaultButton,
                            onPressed: () async {
                            },
                            child: (_isLoading)
                                ? const SizedBox(
                                width: Dimens.buttonIndicatorWidth,
                                height: Dimens.buttonIndicatorHeight,
                                child: CircularProgressIndicator(
                                  color: OwnerColors.colorAccent,
                                  strokeWidth: Dimens.buttonIndicatorStrokes,
                                ))
                                :  Text("Escolher",
                                style: Styles().styleDefaultTextButton),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 12,),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(Dimens.paddingApplication),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pro",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: Dimens.textSize8,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8),
                        ),
                        SizedBox(
                          height: Dimens.marginApplication,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'R\$ ',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Dimens.textSize6,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.2),
                              ),
                              TextSpan(
                                  text: "90,00",
                                  style: TextStyle(
                                      fontSize: Dimens.textSize10,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.2)),
                              TextSpan(
                                text: '/mês',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Dimens.textSize6,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimens.marginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: OwnerColors.colorPrimaryDark,
                            ),
                            SizedBox(width: 8,),
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
                          height: Dimens.minMarginApplication,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Dimens.marginApplication),
                          height: 42,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: Styles().styleDefaultButton,
                            onPressed: () async {
                            },
                            child: (_isLoading)
                                ? const SizedBox(
                                width: Dimens.buttonIndicatorWidth,
                                height: Dimens.buttonIndicatorHeight,
                                child: CircularProgressIndicator(
                                  color: OwnerColors.colorAccent,
                                  strokeWidth: Dimens.buttonIndicatorStrokes,
                                ))
                                :  Text("Escolher",
                                style: Styles().styleDefaultTextButton),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 32,),
              ],
            ),
          ),
        ])));
  }
}
