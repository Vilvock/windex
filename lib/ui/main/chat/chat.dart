import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:windex/res/assets.dart';
import 'package:windex/res/styles.dart';
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
import '../../components/custom_app_bar.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Chat", isVisibleBackButton: true, isNotVisibleLine: true, isChat: true,),
        body: /* FutureBuilder<List<Map<String, dynamic>>>(
            future: listNotifications(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final responseItem = User.fromJson(snapshot.data![0]);

                if (responseItem.rows != 0) {
                  return */
            Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: /*snapshot.data!.length*/ 10,
              itemBuilder: (context, index) {
                // final response = User.fromJson(snapshot.data![index]);

                if (index == 0 || index == 5 || index == 6) {
                  return InkWell(
                      onTap: () => {},
                      child: Column (children: [

                        SizedBox(height: Dimens.marginApplication,),
                        Row(
                        children: [
                          SizedBox(width: 2,),
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimens.minMarginApplication,
                                right: Dimens.minMarginApplication),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(24),
                                // Image radius
                                child: Image.network(
                                    ApplicationConstant.URL_PRODUCT,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, exception, stackTrack) =>
                                            Image.asset(
                                              Assets.person,
                                            )),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16) ,
                            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.40, maxWidth: MediaQuery.of(context).size.width * 0.80, ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.maxRadiusApplication)),
                            ),
                            child: Text(
                              Strings.littleLoremIpsum,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: Dimens.textSize5,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ],
                      )]));
                } else {

                  return InkWell(
                      onTap: () => {},
                      child: Column (children: [

                        SizedBox(height: Dimens.marginApplication,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Container(
                              padding: EdgeInsets.all(16) ,
                              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.40, maxWidth: MediaQuery.of(context).size.width * 0.80, ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      OwnerColors.gradientFirstColor,
                                      OwnerColors.gradientSecondaryColor,
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.maxRadiusApplication)),
                              ),
                              child: Text(
                                Strings.littleLoremIpsum,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),

                            SizedBox(width: 10,),
                            // Container(
                            //   margin: EdgeInsets.only(
                            //       left: Dimens.minMarginApplication,
                            //       right: Dimens.minMarginApplication),
                            //   child: ClipOval(
                            //     child: SizedBox.fromSize(
                            //       size: Size.fromRadius(22),
                            //       // Image radius
                            //       child: Image.network(
                            //           ApplicationConstant.URL_PRODUCT,
                            //           fit: BoxFit.cover,
                            //           errorBuilder:
                            //               (context, exception, stackTrack) =>
                            //               Image.asset(
                            //                 Assets.person,
                            //               )),
                            //     ),
                            //   ),
                            // ),
                          ],
                        )]));
                }
              },
            )),
            Container(
                padding: EdgeInsets.all(Dimens.paddingApplication),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF494949),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.maxRadiusApplication)),
                            ),
                            child: IntrinsicHeight(
                                child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Digite sua mensagem...',
                                      hintStyle: TextStyle(color: Colors.white),
                                      filled: false,
                                      border: InputBorder.none,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.all(
                                          Dimens.textFieldPaddingApplication),
                                    ),
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: Dimens.textSize5,
                                    ),
                                  ),
                                ),
                                IconButton(
                                    constraints: BoxConstraints(
                                        minWidth: 0, minHeight: 0),
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.mic,
                                      color: Colors.white,
                                    )),
                                SizedBox(
                                  width: 4,
                                )
                              ],
                            )))),
                    SizedBox(
                      width: 14,
                    ),
                    Container(
                        child: RawMaterialButton(
                      constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      onPressed: () {},
                      elevation: Dimens.elevationApplication,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.send,
                        color: Colors.black87,
                        size: 34,
                      ),
                      padding: EdgeInsets.all(8),
                      shape: CircleBorder(),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ))
          ],
        )

        //       } else {
        //         return Container(
        //             padding: EdgeInsets.only(
        //                 top: MediaQuery.of(context)
        //                     .size
        //                     .height /
        //                     20),
        //             child: Column(
        //                 mainAxisAlignment:
        //                 MainAxisAlignment.center,
        //                 children: [
        //                   Center(
        //                       child: Lottie.network(
        //                           height: 160,
        //                           'https://assets10.lottiefiles.com/packages/lf20_KZ1htY.json')),
        //                   SizedBox(
        //                       height: Dimens
        //                           .marginApplication),
        //                   Text(
        //                     Strings.empty_list,
        //                     style: TextStyle(
        //                       fontFamily: 'Inter',
        //                       fontSize: Dimens.textSize5,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                 ]));
        //       }
        //     } else if (snapshot.hasError) {
        //       print("**************************************************************\n*******************************************" + snapshot.error.toString());
        //       return Styles().defaultErrorRequest;
        //     }
        //     return Styles().defaultLoading;
        //   },
        // ),

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
