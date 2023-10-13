import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/application_messages.dart';
import '../../../config/preferences.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';
import '../../components/gradient_text.dart';
import '../../main/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool _passwordVisible;
  late bool _isLoading = false;

  late Validator validator;
  final postRequest = PostRequest();
  User? _loginResponse;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    validator = Validator(context: context);

    _passwordVisible = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginRequest(String email, String password) async {
    try {
      final body = {
        "email": email,
        "password": password,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.LOGIN, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        _loginResponse = response;

        await Preferences.setUserData(_loginResponse);
        await Preferences.setLogin(true);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            ModalRoute.withName("/ui/home"));
      } else {}
      ApplicationMessages(context: context).showMessage(response.msg);
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body:
        Container(
              color: OwnerColors.colorAccent,
              child: SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                    child: CustomScrollView(slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GradientText(
                              align: TextAlign.start,
                              "Acessar conta",
                              style: TextStyle(
                                  fontSize: Dimens.textSize8,
                                  color: OwnerColors.colorPrimaryDark,
                                  fontWeight: FontWeight.w900),
                              gradient: LinearGradient(colors: [
                                OwnerColors.gradientFirstColor,
                                OwnerColors.gradientSecondaryColor,
                                OwnerColors.gradientThirdColor
                              ]),
                            ),
                            Text(
                              "Insira seu email e senha.",
                              style: TextStyle(
                                  fontSize: Dimens.textSize6,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  height: 1.5
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 32),
                            Container(
                              width: double.infinity,
                              margin:
                              EdgeInsets.only(bottom: Dimens.minMarginApplication),
                              child: Text(
                                "E-mail",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: Dimens.textSize4,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 2),
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
                            ),
                            SizedBox(height: 32),
                            Container(
                              width: double.infinity,
                              margin:
                              EdgeInsets.only(bottom: Dimens.minMarginApplication),
                              child: Text(
                                "Senha",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: Dimens.textSize4,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 2),
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70, width: 0.8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey, width: 0.4),
                                ),
                                hintText: '',
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
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !_passwordVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Dimens.textSize5,
                              ),
                            ),
                            SizedBox(height: Dimens.marginApplication),
                            Container(
                                width: double.infinity,
                                child: RichText(
                                  textAlign: TextAlign.end,
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: Dimens.textSize5,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: ''),
                                      TextSpan(
                                          text: 'Esqueci minha senha',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Dimens.textSize6,
                                            fontWeight: FontWeight.w300,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                    //           final result = await showModalBottomSheet<dynamic>(
                                    //               isScrollControlled: true,
                                    //               context: context,
                                    //               shape: Styles().styleShapeBottomSheet,
                                    //               clipBehavior: Clip.antiAliasWithSaveLayer,
                                    //               builder: (BuildContext context) {
                                    //                 return EmailAlertDialog();
                                    //               });
                                    //           if (result == true) {
                                    //             Navigator.pushNamed(
                                    //               context,
                                    //               "/ui/wait",
                                    //               /*   arguments: {
                                    //   "id_product": response.id,
                                    // }*/
                                    //             );
                                    //           }
                                              // Navigator.pushNamed(
                                              //     context, "/ui/recover_password");
                                            }),
                                    ],
                                  ),
                                )),
                            SizedBox(height: 48),
                            Container(
                              margin: EdgeInsets.only(top: Dimens.marginApplication),
                              height: 52,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: Styles().styleDefaultButton,
                                onPressed: () async {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => Home()),
                                      ModalRoute.withName("/ui/home"));

                                  if (!validator.validateEmail(emailController.text))
                                    return;

                                  setState(() {
                                    _isLoading = true;
                                  });
                                  // if (!validator.validatePassword(passwordController.text)) return;
                                  await Preferences.init();
                                  await loginRequest(
                                      emailController.text, passwordController.text);

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
                            Container(
                              width: double.infinity,
                              margin:
                              EdgeInsets.only(bottom: Dimens.minMarginApplication),
                              child: Text(
                                "ou",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Dimens.textSize6,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(alignment: Alignment.center, width: double.infinity, child:
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: Dimens.textSize5,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Não possui uma conta? ',style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimens.textSize6,
                                    fontWeight: FontWeight.w300,
                                  ),),
                                  TextSpan(
                                      text: 'Cadastre-se',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimens.textSize6,
                                        fontWeight: FontWeight.w900,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pop(context);
                                        }),
                                ],
                              ),
                            )),

                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ]),
                  )))
        );
  }
}
