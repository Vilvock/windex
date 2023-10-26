import 'dart:convert';

import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
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

class VirtualRoom extends StatefulWidget {
  const VirtualRoom({Key? key}) : super(key: key);

  @override
  State<VirtualRoom> createState() => _VirtualRoom();
}

class _VirtualRoom extends State<VirtualRoom> with TickerProviderStateMixin {
  late PageController _pageController;
  int _pageIndex = 0;

  final postRequest = PostRequest();
  User? _profileResponse;

  late bool _isLoading = false;

  late TabController _tabController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
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
            title: "Sala Virtual",
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
                    ])),
            Container(
              height: 60,
              child: TabBar(
                tabs: [
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Presentes",
                          style: TextStyle(
                            fontSize: Dimens.textSize5,
                            fontWeight: FontWeight.w900,
                          )),
                    ],
                  )),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text("Matchs",
                            style: TextStyle(
                              fontSize: Dimens.textSize5,
                              fontWeight: FontWeight.w900,
                            ))
                      ]))
                ],
                unselectedLabelColor: Colors.grey,
                indicatorColor: OwnerColors.colorPrimary,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 1.8,
                isScrollable: false,
                controller: _tabController,
                onTap: (value) {
                  setState(() {
                    // if (value == 0) {
                    //   _isChanged = false;
                    // } else {
                    //   _isChanged = true;
                    // }
                  });

                  print(value);
                },
              ),
            ),
            Container(
              child: AutoScaleTabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 1.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /*    FutureBuilder<List<Map<String, dynamic>>>(
                                            future: getSpecies(widget.idAuction!),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final responseItem = GraphicModel.fromJson(snapshot.data![0]);

                                                if (responseItem.rows != 0) {
                                                  return*/
                            ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: /*snapshot.data!.length*/
                                  8,
                              itemBuilder: (BuildContext context, int index) {
                                // final response =
                                // GraphicModel.fromJson(snapshot.data![index]);

                                return InkWell(
                                    onTap: () => {},
                                    child: Container(
                                        child: Column(
                                      children: [
                                        SizedBox(
                                          height: Dimens.marginApplication,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: Dimens
                                                      .minMarginApplication,
                                                  right: Dimens
                                                      .minMarginApplication),
                                              child: ClipOval(
                                                child: SizedBox.fromSize(
                                                  size: Size.fromRadius(28),
                                                  // Image radius
                                                  child: Image.network(
                                                      ApplicationConstant
                                                          .URL_PRODUCT,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                              exception,
                                                              stackTrack) =>
                                                          Image.asset(
                                                            'images/main_icon.png',
                                                          )),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Bezerra da Silva",
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: Dimens.textSize6,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimens
                                                      .minMarginApplication,
                                                ),
                                                Text(
                                                  "24 anos | Feminino",
                                                  style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize:
                                                          Dimens.textSize5,
                                                      color: OwnerColors
                                                          .colorPrimaryDark,
                                                      letterSpacing: 1.2),
                                                )
                                              ],
                                            )),
                                            SizedBox(
                                              width:
                                                  Dimens.minMarginApplication,
                                            ),
                                            Container(
                                                child: RawMaterialButton(
                                                  constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                                  onPressed: () {},
                                                  elevation: Dimens
                                                      .elevationApplication,
                                                  fillColor: OwnerColors.darkGrey,
                                                  child: Icon(
                                                    Icons
                                                        .close,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                                  padding: EdgeInsets.all(8),
                                                  shape: CircleBorder(),
                                                )),
                                            SizedBox(width: 14,),
                                            Container(
                                                child: RawMaterialButton(
                                                  constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                                  onPressed: () {},
                                                  elevation: Dimens
                                                      .elevationApplication,
                                                  fillColor: OwnerColors.colorPrimary,
                                                  child: Icon(
                                                    Icons
                                                        .favorite,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                                  padding: EdgeInsets.all(8),
                                                  shape: CircleBorder(),
                                                )),

                                            SizedBox(width: 10,),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimens.marginApplication,
                                        ),
                                        Styles().div_horizontal,
                                      ],
                                    )));
                              },
                            ),

                            SizedBox(height: Dimens.marginApplication,),
                            Container(
                              margin: EdgeInsets.all(Dimens.marginApplication),
                              height: 52,
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: Styles().styleOutlinedRedButton,
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
                                      :  Text("Sair do evento",
                                    style: TextStyle(
                                        fontSize: Dimens.textSize6,
                                        color: OwnerColors.colorPrimary,
                                        wordSpacing: 0.5,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ),
                          ],
                        )),

                    Container(
                        height: MediaQuery.of(context).size.height * 1.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /*    FutureBuilder<List<Map<String, dynamic>>>(
                                            future: getSpecies(widget.idAuction!),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final responseItem = GraphicModel.fromJson(snapshot.data![0]);

                                                if (responseItem.rows != 0) {
                                                  return*/
                            ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: /*snapshot.data!.length*/
                              8,
                              itemBuilder: (BuildContext context, int index) {
                                // final response =
                                // GraphicModel.fromJson(snapshot.data![index]);

                                return InkWell(
                                    onTap: () => {},
                                    child: Container(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: Dimens.marginApplication,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: Dimens
                                                          .minMarginApplication,
                                                      right: Dimens
                                                          .minMarginApplication),
                                                  child: ClipOval(
                                                    child: SizedBox.fromSize(
                                                      size: Size.fromRadius(28),
                                                      // Image radius
                                                      child: Image.network(
                                                          ApplicationConstant
                                                              .URL_PRODUCT,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context,
                                                              exception,
                                                              stackTrack) =>
                                                              Image.asset(
                                                                'images/main_icon.png',
                                                              )),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Bezerra da Silva",
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: Dimens.textSize6,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: Dimens
                                                              .minMarginApplication,
                                                        ),
                                                        Text(
                                                          "24 anos | Feminino",
                                                          style: TextStyle(
                                                              fontFamily: 'Inter',
                                                              fontSize:
                                                              Dimens.textSize5,
                                                              color: OwnerColors
                                                                  .colorPrimaryDark,
                                                              letterSpacing: 1.2),
                                                        )
                                                      ],
                                                    )),
                                                SizedBox(
                                                  width:
                                                  Dimens.minMarginApplication,
                                                ),

                                                Container(
                                                    child: RawMaterialButton(
                                                      constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                                      onPressed: () {},
                                                      elevation: Dimens
                                                          .elevationApplication,
                                                      fillColor: OwnerColors.colorPrimaryDark,
                                                      child: Icon(
                                                        Icons
                                                            .chat_outlined,
                                                        color: Colors.white,
                                                        size: 22,
                                                      ),
                                                      padding: EdgeInsets.all(8),
                                                      shape: CircleBorder(),
                                                    )),

                                                SizedBox(width: 10,),
                                              ],
                                            ),
                                            SizedBox(
                                              height: Dimens.marginApplication,
                                            ),
                                            Styles().div_horizontal,
                                          ],
                                        )));
                              },
                            ),

                            SizedBox(height: Dimens.marginApplication,),
                            Container(
                              margin: EdgeInsets.all(Dimens.marginApplication),
                              height: 52,
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: Styles().styleOutlinedRedButton,
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
                                      :  Text("Sair do evento",
                                    style: TextStyle(
                                        fontSize: Dimens.textSize6,
                                        color: OwnerColors.colorPrimary,
                                        wordSpacing: 0.5,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ),
                          ],
                        )),
                  ]),
            ),
          ],
        ))));
  }
}
