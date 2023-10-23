import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/preferences.dart';
import '../../../global/application_constant.dart';
import '../../../model/user.dart';
import '../../../res/assets.dart';
import '../../../res/dimens.dart';
import '../../../res/owner_colors.dart';
import '../../../res/styles.dart';
import '../../../web_service/links.dart';
import '../../../web_service/service_response.dart';
import '../../components/custom_app_bar.dart';
import '../../components/gradient_text.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetails();
}

class _EventDetails extends State<EventDetails> {
  final postRequest = PostRequest();
  User? _profileResponse;

  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Detalhes do Evento", isVisibleBackButton: true),
        body: Container(
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                child: SafeArea(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                        width: double.infinity,
                        child: ClipRRect(
                            child: Image.network(
                              Assets.generic_party,
                              fit: BoxFit.fitWidth,
                              height: 220,
                              errorBuilder:
                                  (context, exception, stackTrack) =>
                                  Image.asset(
                                    fit: BoxFit.fitWidth,
                                    Assets.generic_party,
                                    height: 220,
                                  ),
                            ))),

                  ],
                )),
              ),
            ])));
  }
}
