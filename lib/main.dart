import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:windex/res/owner_colors.dart';
import 'package:windex/ui/auth/login/login.dart';
import 'package:windex/ui/auth/register/register_owner_data.dart';
import 'package:windex/ui/intro/onboarding.dart';
import 'package:windex/ui/intro/splash.dart';
import 'package:windex/ui/main/home.dart';

import 'config/notification_helper.dart';
import 'config/preferences.dart';
import 'config/useful.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   LocalNotification.showNotification(message);
//   print("Handling a background message: $message");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Preferences.init();
  //
  // if (Platform.isAndroid) {
  //   await Firebase.initializeApp();
  // } else if (Platform.isIOS){
  //   await Firebase.initializeApp(
  //     /*options: FirebaseOptions(
  //     apiKey: WSConstants.API_KEY,
  //     appId: WSConstants.APP_ID,
  //     messagingSenderId: WSConstants.MESSGING_SENDER_ID,
  //     projectId: WSConstants.PROJECT_ID,
  //   )*/);
  // }
  //
  // LocalNotification.initialize();
  //
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  //
  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   print('User granted provisional permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }
  //
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   LocalNotification.showNotification(message);
  //   print('Mensagem recebida: ${message.data}');
  // });
  //
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('Mensagem abertaaaaaaaaa: ${message.data}');
  //
  // });
  //
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MaterialApp(
    theme: ThemeData(
        scaffoldBackgroundColor: OwnerColors.colorAccent,
        //fundo de todo app
        primarySwatch: Useful().getMaterialColor(OwnerColors.colorPrimary),
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Useful().getMaterialColor(OwnerColors.colorPrimary)),
        fontFamily: 'MontSerrat',
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: OwnerColors.colorAccent)),
    debugShowCheckedModeBanner: false,
    title: "Windex",
    initialRoute: '/ui/splash',
    color: OwnerColors.colorPrimary,
    routes: {
      '/ui/splash': (context) => Splash(),
      '/ui/onboarding': (context) => Onboarding(),
      '/ui/login': (context) => Login(),
      '/ui/register': (context) => RegisterOwnerData(),
      '/ui/home': (context) => Home(),
      // '/ui/profile': (context) => Profile(),
      // '/ui/pdf_viewer': (context) => PdfViewer(),
      // '/ui/success': (context) => Success(),
      // '/ui/success2': (context) => Success2(),
      // '/ui/notifications': (context) => Notifications(),
      // '/ui/recover_password': (context) => RecoverPassword(),
      // '/ui/product_detail': (context) => ProductDetail(),
      // '/ui/order_detail': (context) => OrderDetail(),
      // '/ui/begin': (context) => Begin(),
      // '/ui/step_2': (context) => Step2(),
      // '/ui/step_3': (context) => Step3(),
      // '/ui/step_4': (context) => Step4(),
      // '/ui/cart': (context) => CartShopping(),
    },
  ));
}
