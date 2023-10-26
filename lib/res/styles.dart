import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:windex/res/strings.dart';

import 'dimens.dart';
import 'owner_colors.dart';

class Styles {

  var styleDefaultButton = ButtonStyle(
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          // Change your radius here
          borderRadius: BorderRadius.circular(Dimens.radiusApplication),
        )),
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(Dimens.buttonPaddingApplication)),
    backgroundColor: MaterialStateProperty.all(OwnerColors.colorPrimary),
  );

  var styleDefaultButtonMinimalPadding = ButtonStyle(
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          // Change your radius here
          borderRadius: BorderRadius.circular(Dimens.radiusApplication),
        )),
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(2)),
    backgroundColor: MaterialStateProperty.all(OwnerColors.colorPrimary),
  );

  var styleDefaultButtonMinimalPadding2 = ButtonStyle(
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          // Change your radius here
          borderRadius: BorderRadius.circular(Dimens.radiusApplication),
        )),
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(2)),
    backgroundColor: MaterialStateProperty.all(OwnerColors.lightGrey),
  );

  var styleAlternativeButton = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(Dimens.buttonPaddingApplication)),
    backgroundColor: MaterialStateProperty.all(OwnerColors.colorPrimaryDark),
  );

  var styleOutlinedRedButton = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(Dimens.buttonPaddingApplication)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.radiusApplication))),
    side: MaterialStateProperty.all(BorderSide(
        color: OwnerColors.colorPrimary,
        width: 1.6,
        style: BorderStyle.solid)),
    backgroundColor: MaterialStateProperty.all(OwnerColors.colorAccent),
  );

  var styleOutlinedButton = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(Dimens.buttonPaddingApplication)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.radiusApplication))),
    side: MaterialStateProperty.all(BorderSide(
        color: OwnerColors.lightGrey,
        width: 0.2,
        style: BorderStyle.solid)),
    backgroundColor: MaterialStateProperty.all(OwnerColors.colorAccent),
  );

  var styleDefaultTextButton = TextStyle(
      fontSize: Dimens.textSize6,
      color: Colors.white,
      wordSpacing: 0.5,
      fontWeight: FontWeight.w700);

  var styleDefaultTextButton2 = TextStyle(
      fontSize: Dimens.textSize4,
      color: Colors.white,
      wordSpacing: 0.5,
      fontWeight: FontWeight.w700);

  var styleDefaultTextButton3 = TextStyle(
      fontSize: Dimens.textSize4,
      color: Colors.grey,
      wordSpacing: 0.5,
      fontWeight: FontWeight.w700);

  var styleAlternativeTextButton = TextStyle(
      fontSize: Dimens.textSize6,
      color: Colors.white,
      wordSpacing: 0.5,
      fontWeight: FontWeight.w700);

  var styleOutlinedTextButton = TextStyle(
      fontSize: Dimens.textSize6,
      color: Colors.white,
      wordSpacing: 0.5,
      fontWeight: FontWeight.w700);

  var styleOutlinedTextButton2 = TextStyle(
      fontSize: Dimens.textSize5,
      color: Colors.white,
      wordSpacing: 0.5,
      fontWeight: FontWeight.w500);

  var styleShapeBottomSheet = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(Dimens.radiusApplication),
    ),
  );

  var div_horizontal = Divider(
    color: OwnerColors.lightGrey,
    height: 0.2,
    thickness: 0.1,
  );

  var div_vertical = VerticalDivider(
    color: OwnerColors.lightGrey,
    width: 1,
    thickness: 0.4,
  );

  var defaultLoading = Center(child: CircularProgressIndicator());

  var defaultErrorRequest = Container(margin: EdgeInsets.all(Dimens.marginApplication) ,child: Text(
      style: TextStyle(color: Colors.white),
      Strings.no_connection_description));
}
