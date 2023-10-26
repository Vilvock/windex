import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        "id_user": await Preferences.getUserData()!.id ,
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
      appBar: CustomAppBar(title: "Chat", isVisibleBackButton: true),
      body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child:/* FutureBuilder<List<Map<String, dynamic>>>(
            future: listNotifications(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final responseItem = User.fromJson(snapshot.data![0]);

                if (responseItem.rows != 0) {
                  return */ListView.builder(
                    itemCount: /*snapshot.data!.length*/ 3,
                    itemBuilder: (context, index) {


                      // final response = User.fromJson(snapshot.data![index]);

                      return InkWell(
                          onTap: () => {

                          },
                          child: Container(
                              padding: EdgeInsets.only(right:
                                  Dimens.maxPaddingApplication, left: Dimens.maxPaddingApplication),
                              child: Column(children: [
                                SizedBox(height: Dimens.marginApplication,),


                                Styles().div_horizontal,

                              ],)

                          ));
                    },
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
        ),
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
