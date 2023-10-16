import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:windex/res/assets.dart';

import '../../config/application_messages.dart';
import '../../config/masks.dart';
import '../../config/preferences.dart';
import '../../config/validator.dart';
import '../../global/application_constant.dart';
import '../../model/user.dart';
import '../../res/dimens.dart';
import '../../res/owner_colors.dart';
import '../../res/styles.dart';
import '../../web_service/links.dart';
import '../../web_service/service_response.dart';

class EventNotYetAlertDialog extends StatefulWidget {
  EventNotYetAlertDialog({Key? key});

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<EventNotYetAlertDialog> createState() => _EmailAlertDialog();
}

class _EmailAlertDialog extends State<EventNotYetAlertDialog> {

  late bool _isLoading = false;

  final postRequest = PostRequest();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                Dimens.paddingApplication,
                Dimens.paddingApplication,
                Dimens.paddingApplication,
                MediaQuery.of(context).viewInsets.bottom +
                    Dimens.paddingApplication),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
                // SizedBox(height: Dimens.minMarginApplication),
                Image.asset(Assets.gold_scan, height: 80, width: 80,),
                SizedBox(height: Dimens.minMarginApplication),
                Text(
                  textAlign: TextAlign.center,
                  "Evento não iniciado.",
                  style: TextStyle(
                    fontSize: Dimens.textSize7,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimens.marginApplication),
                Text(
                  textAlign: TextAlign.center,
                  "O evento que você tentou escanear ainda não começou.",
                  style: TextStyle(
                    fontSize: Dimens.textSize6,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimens.marginApplication),
                SizedBox(height: Dimens.marginApplication),


                Container(
                  margin: EdgeInsets.only(top: Dimens.marginApplication),
                  height: 52,
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
                        :  Text("Ok",
                        style: Styles().styleDefaultTextButton),
                  ),
                ),

                SizedBox(height: Dimens.marginApplication),


              ],
            ),
          ),
        ]));
  }
}
