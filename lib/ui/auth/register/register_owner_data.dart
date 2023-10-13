import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/application_messages.dart';
import '../../../config/masks.dart';
import '../../../config/validator.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/alert_dialog_sucess.dart';
import '../../components/custom_app_bar.dart';
import '../../components/dot_indicator.dart';
import '../../components/gradient_text.dart';
import '../../main/home.dart';

class RegisterOwnerData extends StatefulWidget {
  const RegisterOwnerData({Key? key}) : super(key: key);

  @override
  State<RegisterOwnerData> createState() => _RegisterOwnerDataState();
}

class _RegisterOwnerDataState extends State<RegisterOwnerData> {
  late PageController _pageController;
  int _pageIndex = 0;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController coPasswordController = TextEditingController();
  final TextEditingController socialReasonController = TextEditingController();

// final TextEditingController iEController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  late bool _passwordVisible;
  late bool _passwordVisible2;

  bool hasPasswordCoPassword = false;
  bool hasUppercase = false;
  bool hasMinLength = false;
  bool visibileOne = false;
  bool visibileTwo = false;

  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _passwordVisible = false;
    _passwordVisible2 = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    coPasswordController.dispose();
    socialReasonController.dispose();
    // iEController.dispose();
    cnpjController.dispose();
    cpfController.dispose();
    cellphoneController.dispose();
    nameController.dispose();

    _pageController.dispose();
    super.dispose();
  }

  late Validator validator;
  final postRequest = PostRequest();
  User? _registerResponse;

  Future<void> registerRequest(
      /*String ie,*/
      String email,
      String password,
      String fantasyName,
      String socialReason,
      String document,
      String cellphone,
      String latitude,
      String longitude,
      String typePerson) async {
    try {
      final body = {
        "tipo_pessoa": typePerson,
        "nome": fantasyName,
        "nome_fantasia": fantasyName,
        "razao_social": socialReason,
        "email": email,
        "password": password,
        "documento": document,
        "telefone": cellphone,
        "celular": cellphone,
        "data_nascimento": "00/00/0000",
        "lat": latitude,
        "long": longitude,
        "token": ApplicationConstant.TOKEN
      };

      print('HTTP_BODY: $body');

      final json = await postRequest.sendPostRequest(Links.REGISTER, body);
      // final parsedResponse = jsonDecode(json); // pegar um objeto so

      List<Map<String, dynamic>> _map = [];
      _map = List<Map<String, dynamic>>.from(jsonDecode(json));

      print('HTTP_RESPONSE: $_map');

      final response = User.fromJson(_map[0]);

      if (response.status == "01") {
        showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          shape: Styles().styleShapeBottomSheet,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          builder: (BuildContext context) {
            return SucessAlertDialog(
                content: response.msg,
                btnConfirm: Container(
                    margin: EdgeInsets.only(top: Dimens.marginApplication),
                    width: double.infinity,
                    child: ElevatedButton(
                        style: Styles().styleDefaultButton,
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text("Ok",
                            style: Styles().styleDefaultTextButton))));
          },
        );
      } else {
        ApplicationMessages(context: context).showMessage(response.msg);
      }
    } catch (e) {
      throw Exception('HTTP_ERROR: $e');
    }
  }

  Future<void> saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = user.toJson();
    await prefs.setString('user', jsonEncode(userData));
  }

  // Future<Position?> determinePosition() async {
  //   LocationPermission permission;
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.deniedForever) {
  //       return Future.error('Location Not Available');
  //     }
  //   } else {
  //     throw Exception('Error');
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }

  @override
  Widget build(BuildContext context) {
    validator = Validator(context: context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: CustomAppBar(isVisibleIcon: true, isVisibleBackButton: true),
      body: Container(
          color: OwnerColors.colorAccent,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: PageView.builder(
                  itemCount: 3,
                  controller: _pageController,
                  // physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                          padding: EdgeInsets.all(Dimens.maxPaddingApplication),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GradientText(
                                align: TextAlign.start,
                                "Cadastrar",
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
                                    height: 1.5),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 32),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    bottom: Dimens.minMarginApplication),
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
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.4),
                                  ),
                                  hintText: 'Digite seu e-mail',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.radiusApplication),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: OwnerColors.colorAccent,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
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
                                margin: EdgeInsets.only(
                                    bottom: Dimens.minMarginApplication),
                                child: Text(
                                  "Senha",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimens.textSize4,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    hasPasswordCoPassword = false;
                                    visibileOne = true;
                                    hasMinLength =
                                        passwordController.text.length >= 8;
                                    hasUppercase = passwordController.text
                                        .contains(RegExp(r'[A-Z]'));

                                    hasPasswordCoPassword =
                                        coPasswordController.text ==
                                            passwordController.text;

                                    if (hasMinLength && hasUppercase) {
                                      visibileOne = false;
                                    }
                                  });
                                },
                                controller: passwordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: OwnerColors.colorPrimary,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      }),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white70, width: 0.8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.4),
                                  ),
                                  hintText: 'Digite seu e-mail',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.radiusApplication),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: OwnerColors.colorAccent,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
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
                              SizedBox(height: 4),
                              Visibility(
                                visible: passwordController.text.isNotEmpty,
                                child: Row(
                                  children: [
                                    Icon(
                                      hasMinLength
                                          ? Icons.check_circle
                                          : Icons.check_circle,
                                      color: hasMinLength
                                          ? Colors.green
                                          : OwnerColors.lightGrey,
                                    ),
                                    Text(
                                      'Deve ter no mínimo 8 carácteres',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: passwordController.text.isNotEmpty,
                                child: Row(
                                  children: [
                                    Icon(
                                      hasUppercase
                                          ? Icons.check_circle
                                          : Icons.check_circle,
                                      color: hasUppercase
                                          ? Colors.green
                                          : OwnerColors.lightGrey,
                                    ),
                                    Text(
                                      'Deve ter uma letra maiúscula',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 32),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    bottom: Dimens.minMarginApplication),
                                child: Text(
                                  "Confirmar Senha",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimens.textSize4,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    visibileTwo = true;
                                    hasPasswordCoPassword =
                                        coPasswordController.text ==
                                            passwordController.text;

                                    if (hasPasswordCoPassword) {
                                      visibileTwo = false;
                                    }
                                  });
                                },
                                controller: coPasswordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: OwnerColors.colorPrimary,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      }),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white70, width: 0.8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.4),
                                  ),
                                  hintText: 'Digite seu e-mail',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.radiusApplication),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: OwnerColors.colorAccent,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !_passwordVisible2,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Visibility(
                                visible: coPasswordController.text.isNotEmpty,
                                child: Row(
                                  children: [
                                    Icon(
                                      hasPasswordCoPassword
                                          ? Icons.check_circle
                                          : Icons.check_circle,
                                      color: hasPasswordCoPassword
                                          ? Colors.green
                                          : OwnerColors.lightGrey,
                                    ),
                                    Text(
                                      'As senhas fornecidas são idênticas',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimens.marginApplication),
                            ],
                          ));
                    } else if (index == 1) {
                      return Container(
                          margin: EdgeInsets.all(Dimens.marginApplication),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    bottom: Dimens.minMarginApplication),
                                child: Text(
                                  "E-mail",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: OwnerColors.colorPrimary,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  hintText: 'exemplo@email.com',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.radiusApplication),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                              SizedBox(height: Dimens.marginApplication),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    bottom: Dimens.minMarginApplication),
                                child: Text(
                                  "Senha",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    hasPasswordCoPassword = false;
                                    visibileOne = true;
                                    hasMinLength =
                                        passwordController.text.length >= 8;
                                    hasUppercase = passwordController.text
                                        .contains(RegExp(r'[A-Z]'));

                                    hasPasswordCoPassword =
                                        coPasswordController.text ==
                                            passwordController.text;

                                    if (hasMinLength && hasUppercase) {
                                      visibileOne = false;
                                    }
                                  });
                                },
                                controller: passwordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: OwnerColors.colorPrimary,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      }),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: OwnerColors.colorPrimary,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  hintText: '',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.radiusApplication),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
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
                              SizedBox(height: 4),
                              Visibility(
                                visible: passwordController.text.isNotEmpty,
                                child: Row(
                                  children: [
                                    Icon(
                                      hasMinLength
                                          ? Icons.check_circle
                                          : Icons.check_circle,
                                      color: hasMinLength
                                          ? Colors.green
                                          : OwnerColors.lightGrey,
                                    ),
                                    Text(
                                      'Deve ter no mínimo 8 carácteres',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: passwordController.text.isNotEmpty,
                                child: Row(
                                  children: [
                                    Icon(
                                      hasUppercase
                                          ? Icons.check_circle
                                          : Icons.check_circle,
                                      color: hasUppercase
                                          ? Colors.green
                                          : OwnerColors.lightGrey,
                                    ),
                                    Text(
                                      'Deve ter uma letra maiúscula',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimens.marginApplication),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    bottom: Dimens.minMarginApplication),
                                child: Text(
                                  "Confirmar Senha",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimens.textSize5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    visibileTwo = true;
                                    hasPasswordCoPassword =
                                        coPasswordController.text ==
                                            passwordController.text;

                                    if (hasPasswordCoPassword) {
                                      visibileTwo = false;
                                    }
                                  });
                                },
                                controller: coPasswordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible2
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: OwnerColors.colorPrimary,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible2 =
                                              !_passwordVisible2;
                                        });
                                      }),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: OwnerColors.colorPrimary,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  hintText: '',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.radiusApplication),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(
                                      Dimens.textFieldPaddingApplication),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !_passwordVisible2,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.textSize5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Visibility(
                                visible: coPasswordController.text.isNotEmpty,
                                child: Row(
                                  children: [
                                    Icon(
                                      hasPasswordCoPassword
                                          ? Icons.check_circle
                                          : Icons.check_circle,
                                      color: hasPasswordCoPassword
                                          ? Colors.green
                                          : OwnerColors.lightGrey,
                                    ),
                                    Text(
                                      'As senhas fornecidas são idênticas',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Dimens.marginApplication,
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: Dimens.textSize5,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            'Ao clicar no botão Criar conta, você aceita os'),
                                    TextSpan(
                                        text: ' Termos de uso',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: Dimens.textSize5,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(
                                                context, "/ui/pdf_viewer");
                                          }),
                                    TextSpan(text: ' do aplicativo.'),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    } else {}
                  },
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      3,
                      (index) => DotIndicator(
                        isActive: index == _pageIndex,
                        color: OwnerColors.colorPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: Dimens.marginApplication,
                        right: Dimens.marginApplication),
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.only(top: Dimens.marginApplication),
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: Styles().styleDefaultButton,
                          onPressed: () async {
                            var _document = "";
                            var _typePerson = "";
                            var _socialReason = "";

                            if (!validator.validateCPF(cpfController.text))
                              return;

                            _document = cpfController.text.toString();
                            _typePerson = 1.toString();
                            _socialReason = "";

                            if (!validator.validateGenericTextField(
                                nameController.text, "Nome")) return;

                            if (!validator.validateCellphone(
                                cellphoneController.text)) return;
                            if (!validator.validateEmail(emailController.text))
                              return;
                            if (!validator.validatePassword(
                                passwordController.text)) return;
                            if (!validator.validateCoPassword(
                                passwordController.text,
                                coPasswordController.text)) return;

                            setState(() {
                              _isLoading = true;
                            });

                            // var position = await determinePosition();

                            await registerRequest(
                                // iEController.text,
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                                socialReasonController.text,
                                _document,
                                cellphoneController.text,
                                "",
                                "",
                                _typePerson);

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
                              : Text("Criar Conta",
                                  style: Styles().styleDefaultTextButton),
                        ),
                      ),
                      SizedBox(height: Dimens.minMarginApplication),
                      SizedBox(height: Dimens.minMarginApplication),
                      SizedBox(height: Dimens.minMarginApplication),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Já possui uma conta?  ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.textSize5,
                                  fontWeight: FontWeight.w300,
                                  wordSpacing: 0.5),
                            ),
                            TextSpan(
                                text: 'Faça login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimens.textSize5,
                                    fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.underline,
                                    wordSpacing: 0.5),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context);
                                  }),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                    ]))
              ],
            ),
          )),
    );
  }
}
