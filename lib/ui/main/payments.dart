import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:windex/res/assets.dart';
import 'package:windex/res/styles.dart';
import 'package:windex/ui/components/alert_dialog_wallet.dart';
import '../../../../config/application_messages.dart';
import '../../../../config/preferences.dart';
import '../../../../config/validator.dart';
import '../../../../global/application_constant.dart';
import '../../../../model/user.dart';
import '../../../../res/dimens.dart';
import '../../../../res/owner_colors.dart';
import '../../../../res/strings.dart';
import '../../../../web_service/links.dart';
import '../../../../web_service/service_response.dart';
import '../components/custom_app_bar.dart';

class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  State<Payments> createState() => _Payments();
}

class _Payments extends State<Payments> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final postRequest = PostRequest();

  Future<List<Map<String, dynamic>>> listNotifications() async {
    try {
      final body = {
        "id_user": await Preferences.getUserData()!.id,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
          await postRequest.sendPostRequest(Links.LIST_NOTIFICATIONS, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return OwnerColors.colorPrimary;
      }
      return OwnerColors.colorPrimaryDark;
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Meus cartões", isVisibleBackButton: true),
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  /*FutureBuilder<List<Map<String, dynamic>>>(
            future: listNotifications(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final responseItem = User.fromJson(snapshot.data![0]);

                if (responseItem.rows != 0) {
                  return*/
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: /*snapshot.data!.length*/ 3,
                    itemBuilder: (context, index) {
                      // final response = User.fromJson(snapshot.data![index]);

                      bool isChecked = index == 1 ? true : false;

                      return InkWell(
                          onTap: () => {},
                          child: Container(
                              padding:
                                  EdgeInsets.all(Dimens.maxPaddingApplication),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: Dimens.minMarginApplication),
                                        child: Image.network(
                                          ApplicationConstant.URL_PRODUCT,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, exception,
                                                  stackTrack) =>
                                              Image.asset(
                                            Assets.card,
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                        "•••• •••• •••• 4747 (Crédito)",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: Dimens.textSize5,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            wordSpacing: 1.2),
                                      )),
                                      SizedBox(
                                        width: Dimens.minMarginApplication,
                                      ),
                                      Checkbox(
                                        checkColor: OwnerColors.colorAccent,
                                        activeColor:
                                            OwnerColors.colorPrimaryDark,
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {});
                                        },
                                      ),
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
                      Container(padding: EdgeInsets.all(Dimens.paddingApplication) ,child:
                      Row(
                        children: [
                          InkWell(
                              onTap: () async {
                                showModalBottomSheet<dynamic>(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: Styles().styleShapeBottomSheet,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (BuildContext context) {
                                      return WalletAlertDialog();
                                    });
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                padding: EdgeInsets.all(4),
                                margin: EdgeInsets.only(right: 18),
                                child: Icon(Icons.add, color: Colors.white, size: 18),
                                decoration: BoxDecoration(
                                  color: OwnerColors.colorAccent,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    color: Colors.white70,
                                    width: 1,
                                  ),
                                ),
                              )),
                          Expanded(
                            child: Text(
                              "Ad. cartão de crédito",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: Dimens.textSize5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )),
                      /*;
                } else {
                  return Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context)
                              .size
                              .height /
                              20),
                      child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Lottie.network(
                                    height: 160,
                                    'https://assets10.lottiefiles.com/packages/lf20_KZ1htY.json')),
                            SizedBox(
                                height: Dimens
                                    .marginApplication),
                            Text(
                              Strings.empty_list,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: Dimens.textSize5,
                                color: Colors.white,
                              ),
                            ),
                          ]));
                }
              } else if (snapshot.hasError) {
                return Styles().defaultErrorRequest;
              }
              return Styles().defaultLoading;
            },
          ),*/
                ])
            )
        )
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listFavorites();
      _isLoading = false;
    });
  }
}
