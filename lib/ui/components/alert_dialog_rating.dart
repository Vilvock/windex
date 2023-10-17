import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

class RatingAlertDialog extends StatefulWidget {
  RatingAlertDialog({Key? key});

  // DialogGeneric({Key? key}) : super(key: key);

  @override
  State<RatingAlertDialog> createState() => _RatingAlertDialog();
}

class _RatingAlertDialog extends State<RatingAlertDialog> {
  late bool _isLoading = false;

  final postRequest = PostRequest();

  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
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
                Image.asset(
                  Assets.star,
                  height: 65,
                  width: 65,
                ),
                SizedBox(height: Dimens.marginApplication),
                SizedBox(height: Dimens.minMarginApplication),
                Text(
                  textAlign: TextAlign.center,
                  "Antes de sair..",
                  style: TextStyle(
                    fontSize: Dimens.textSize7,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimens.marginApplication),
                Text(
                  textAlign: TextAlign.center,
                  "Avalie o evento e diga o que achou!",
                  style: TextStyle(
                    fontSize: Dimens.textSize6,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimens.marginApplication),
                SizedBox(height: Dimens.marginApplication),

                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),

                SizedBox(height: Dimens.marginApplication),
                SizedBox(height: Dimens.marginApplication),
                Container(
                  width: double.infinity,
                  margin:
                  EdgeInsets.only(bottom: Dimens.minMarginApplication),
                  child: Text(
                    "Comentário",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: Dimens.textSize4,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                SizedBox(
                    height: 120,
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                  controller: commentController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white70, width: 0.8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey, width: 0.4),
                    ),
                    hintText: 'Diga o que achou...',
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
                    onPressed: () async {},
                    child: (_isLoading)
                        ? const SizedBox(
                            width: Dimens.buttonIndicatorWidth,
                            height: Dimens.buttonIndicatorHeight,
                            child: CircularProgressIndicator(
                              color: OwnerColors.colorAccent,
                              strokeWidth: Dimens.buttonIndicatorStrokes,
                            ))
                        : Text("Sim", style: Styles().styleDefaultTextButton),
                  ),
                ),

                SizedBox(height: Dimens.marginApplication),

              ],
            ),
          ),
        ]));
  }
}
