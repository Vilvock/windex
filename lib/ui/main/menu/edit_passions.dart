import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/preferences.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/gradient_text.dart';

class EditPassions extends StatefulWidget {
  const EditPassions({Key? key}) : super(key: key);

  @override
  State<EditPassions> createState() => _EditPassions();
}

class _EditPassions extends State<EditPassions> {
  final postRequest = PostRequest();
  User? _profileResponse;

  late bool _isLoading = false;

  List<Widget> gridItems = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 8; i++) {
      // final response =
      // Product.fromJson(snapshot.data![i]);

      var source = 'images/cow.png';
      var source2 = 'images/cow.png';

      if (i == 0) {
        source = 'images/cow.png';
        source2 = 'Gado';
      } else if (i == 1) {
        source = 'images/map.png';
        source2 = 'Terras';
      } else {
        source = 'images/gavel.png';
        source2 = 'Outros';
      }

      gridItems.add(InkWell(
          onTap: () => {},
          child: Container(
              margin: EdgeInsets.all(Dimens.minMarginApplication),
              decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: OwnerColors.lightGrey),
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.radiusApplication)),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 30,
                      color: Colors.white,
                    ),
                    // Image.asset(source,
                    //   width: 24, height: 24, color: OwnerColors.colorPrimary,),
                    SizedBox(
                      height: Dimens.minMarginApplication,
                    ),
                    Text(
                      source2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.textSize4,
                      ),
                    ),
                  ]))));
    }
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: EdgeInsets.all(Dimens.maxPaddingApplication),
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Row(children: [
                      GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 26,
                            child:
                                Icon(Icons.arrow_back_ios, color: Colors.white),
                          )),
                      SizedBox(height: 4),
                      Expanded(
                          child: GradientText(
                        align: TextAlign.start,
                        "Editar paixões",
                        style: TextStyle(
                            fontSize: Dimens.textSize8,
                            color: OwnerColors.colorPrimaryDark,
                            fontWeight: FontWeight.w900),
                        gradient: LinearGradient(colors: [
                          OwnerColors.gradientFirstColor,
                          OwnerColors.gradientSecondaryColor,
                          OwnerColors.gradientThirdColor
                        ]),
                      ))
                    ]),
                    Text(
                      "Quais são seus interesses?",
                      style: TextStyle(
                          fontSize: Dimens.textSize6,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          height: 1.5),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 32),

                    /*                             FutureBuilder<List<Map<String, dynamic>>>(
                                  future: listProducts(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var gridItems = <Widget>[];

                                      for (var i = 0; i < 8; i++) {
                                        // final response =
                                        // Product.fromJson(snapshot.data![i]);

                                        var source = 'images/cow.png';
                                        var source2 = 'images/cow.png';

                                        if (i == 0) {
                                          source = 'images/cow.png';
                                          source2 = 'Gado';
                                        } else if (i == 1){

                                          source = 'images/map.png';
                                          source2 = 'Terras';
                                        } else {

                                          source = 'images/gavel.png';
                                          source2 = 'Outros';
                                        }

                                        gridItems.add(InkWell(
                                            onTap: () => {
                                              // Navigator.pushNamed(
                                              //     context, "/ui/subcategories",
                                              //     arguments: {
                                              //       "id_category": response.id,
                                              //     })
                                            },
                                            child: Container(
                                                margin: EdgeInsets.all(
                                                    Dimens.minMarginApplication),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: OwnerColors.lightGrey),
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(36)),
                                                ),
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(source,
                                                        width: 24, height: 24, color: OwnerColors.colorPrimary,),
                                                      SizedBox(
                                                        width: Dimens.minMarginApplication,
                                                      ),
                                                      Text(
                                                        source2,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: Dimens.textSize5,
                                                        ),
                                                      ),
                                                    ]))));
                                      }

                                      return*/
                    Container(
                      // margin: EdgeInsets.only(left: 10, right: 10),
                      child: GridView.count(
                        childAspectRatio: 1.0,
                        primary: false,
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        children: gridItems,
                      ),
                    ),
                    /*;
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                    return Styles().defaultLoading;
                                  }),*/
                    Container(
                      margin: EdgeInsets.only(top: Dimens.marginApplication),
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: Styles().styleDefaultButton,
                        onPressed: () async {},
                        child: (_isLoading)
                            ? const SizedBox(
                                width: Dimens.buttonIndicatorWidth,
                                height: Dimens.buttonIndicatorHeight,
                                child: CircularProgressIndicator(
                                  color: OwnerColors.colorAccent,
                                  strokeWidth: Dimens.buttonIndicatorStrokes,
                                ))
                            : Text("Alterar",
                                style: Styles().styleDefaultTextButton),
                      ),
                    ),
                    SizedBox(height: Dimens.marginApplication),
                  ],
                ),
              ),
            ])));
  }
}
