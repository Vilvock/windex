import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:windex/res/assets.dart';
import 'package:windex/ui/components/alert_dialog_disable_account.dart';
import 'package:windex/ui/components/alert_dialog_logout.dart';
import 'package:windex/ui/main/notifications/notifications.dart';
import 'package:windex/ui/main/plans.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/cart.dart';
import '../../model/item.dart';
import '../../model/product.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../components/alert_dialog_generic.dart';
import '../components/custom_app_bar.dart';
import '../components/dot_indicator.dart';
import '../components/gradient_text.dart';
import 'main_menu.dart';
import 'qr_code_reader.dart';

class Partners extends StatefulWidget {
  const Partners({Key? key}) : super(key: key);

  @override
  State<Partners> createState() => _PartnersState();
}

class _PartnersState extends State<Partners> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  final postRequest = PostRequest();

  List<Widget> gridItems = [];

  late TabController _tabController;

  @override
  void initState() {
    for (var i = 0; i < 8; i++) {
      // final response =
      // Product.fromJson(snapshot.data![i]);

      gridItems.add(InkWell(
          onTap: () => {},
          child: Container(
              margin: EdgeInsets.all(Dimens.minMarginApplication),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.minRadiusApplication)),
              ),
              child: Container(
                child: Stack(
                    alignment: AlignmentDirectional.centerEnd, children: [
                  Container(
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.minRadiusApplication)),
                          child: Image.network(
                            Assets.company,
                            fit: BoxFit.fitWidth,
                            errorBuilder:
                                (context, exception, stackTrack) =>
                                Image.asset(
                                  fit: BoxFit.fitWidth,
                                  Assets.company,
                                ),
                          ))),
                ]),
              )
          )
      )
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
              isVisibleBackButton: true,
              title: "Parceiros",
            ),
            body: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(Dimens.paddingApplication),
                  child: GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: gridItems,
                  ),
                ),
              ],
            ))));
  }
}
