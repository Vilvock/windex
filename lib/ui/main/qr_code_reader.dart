import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:windex/ui/components/alert_dialog_disable_account.dart';
import 'package:windex/ui/components/alert_dialog_event_not_yet.dart';
import 'package:windex/ui/components/alert_dialog_logout.dart';
import 'package:windex/ui/components/alert_dialog_rating.dart';
import 'package:windex/ui/components/alert_dialog_wallet.dart';
import 'package:windex/ui/components/alert_dialog_windex.dart';

import '../../config/application_messages.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/budget.dart';
import '../../model/detail.dart';
import '../../model/order.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';
import '../auth/login/login.dart';
import '../components/alert_dialog_generic.dart';
import '../components/custom_app_bar.dart';

class QrCodeReader extends StatefulWidget {
  const QrCodeReader({Key? key}) : super(key: key);

  @override
  State<QrCodeReader> createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  bool _isLoading = false;
  bool _isLoadingDialog = false;

  int _pageIndex = 0;

  late Validator validator;
  final postRequest = PostRequest();

  User? _profileResponse;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _isLoading = true;
      // listHighlightsRequest();
      _isLoading = false;
    });
  }
  //
  // Future<List<Map<String, dynamic>>> listOrders() async {
  //   try {
  //     final body = {
  //       "id_usuario": await Preferences.getUserData()!.id,
  //       "token": ApplicationConstant.TOKEN
  //     };
  //
  //     print('HTTP_BODY: $body');
  //
  //     final json = await postRequest.sendPostRequest(Links.LIST_ORDERS, body);
  //     List<Map<String, dynamic>> _map = [];
  //     _map = List<Map<String, dynamic>>.from(jsonDecode(json));
  //
  //     print('HTTP_RESPONSE: $_map');
  //
  //     final response = User.fromJson(_map[0]);
  //
  //     return _map;
  //   } catch (e) {
  //     throw Exception('HTTP_ERROR: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(isVisibleIcon: true),
        resizeToAvoidBottomInset: false,
        body: Container(
            child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height, child: Column(children: [

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
                                  return RatingAlertDialog();
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
                              :  Text("Ok",
                              style: Styles().styleDefaultTextButton),
                        ),
                      ),
                    ]),)
                )
            )
        )
    );
  }
}
