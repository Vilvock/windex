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
      appBar: CustomAppBar(title: "Pagamento", isVisibleBackButton: true),
      body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: listNotifications(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final responseItem = User.fromJson(snapshot.data![0]);

                if (responseItem.rows != 0) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {


                      final response = User.fromJson(snapshot.data![index]);

                      return InkWell(
                          onTap: () => {

                          },
                          child: Container(
                              padding: EdgeInsets.all(
                                  Dimens.maxPaddingApplication),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: Dimens
                                              .minMarginApplication),
                                      child: ClipOval(
                                        child: SizedBox.fromSize(
                                          size:
                                          Size.fromRadius(28),
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
                                        child:
                                        Text(
                                          Strings.shortLoremIpsum,
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: Dimens
                                                  .textSize5,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              wordSpacing: 1.2
                                          ),
                                        )


                                    ),
                                    SizedBox(width: Dimens.minMarginApplication,),
                                    Text(
                                      "2 minutos atras",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: Dimens
                                            .textSize3,
                                        color: Colors.white70,
                                      ),
                                    )

                                  ],
                                ),

                                SizedBox(height: Dimens.marginApplication,),

                                Styles().div_horizontal,

                                SizedBox(height: Dimens.marginApplication,),
                              ],)

                          ));
                    },
                  );
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
                return Text('${snapshot.error}');
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
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
