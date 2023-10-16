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

class EmailAlertDialog extends StatefulWidget {
  EmailAlertDialog({Key? key});

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<EmailAlertDialog> createState() => _EmailAlertDialog();
}

class _EmailAlertDialog extends State<EmailAlertDialog> {

  late bool _isLoading = false;

  final postRequest = PostRequest();

  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> recoverPasswordByEmail(String email) async {
    try {
      final body = {
        "email": email,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json =
      await postRequest.sendPostRequest(Links.RECOVER_PASSWORD_TOKEN, body);

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {

        Navigator.of(context).pop();
      } else {

      }

      ApplicationMessages(context: context).showMessage(response.msg);
      return _map;
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
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
                Image.asset(Assets.security, height: 55, width: 55,),
                SizedBox(height: Dimens.minMarginApplication),
                SizedBox(height: Dimens.marginApplication),
                Text(
                  textAlign: TextAlign.center,
                  "Insira seu email para enviarmos um link de recuperação.",
                  style: TextStyle(
                    fontSize: Dimens.textSize6,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimens.marginApplication),
                SizedBox(height: Dimens.marginApplication),
                Container(/*margin: EdgeInsets.only(left: Dimens.marginApplication, right: Dimens.marginApplication) ,*/child:
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white70, width: 0.8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey, width: 0.4),
                    ),
                    hintText: 'Digite seu e-mail',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Dimens.radiusApplication),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: OwnerColors.colorAccent,
                    contentPadding:
                    EdgeInsets.all(Dimens.textFieldPaddingApplication),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: Dimens.textSize5,
                  ),
                )),
                SizedBox(height: Dimens.marginApplication),


                Container(
                  margin: EdgeInsets.only(top: Dimens.marginApplication),
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: Styles().styleDefaultButton,
                    onPressed: () async {

                      setState(() {
                        _isLoading = true;
                      });

                      await recoverPasswordByEmail(emailController.text.toString());

                      setState(() {
                        _isLoading = false;
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
                        :  Text("Entrar",
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
