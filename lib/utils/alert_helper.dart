import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlertHelper {
  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  static customSnackBar(BuildContext context, String message, bool isError) {
    if (isError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message,
            style: CustomTheme.primaryTextStyle),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message,
            style: CustomTheme.primaryTextStyle
        ),
        backgroundColor: Colors.green,
      ));
    }
  }

  static showAlertDialog(BuildContext context,
      {String title = "",
        String message = "",
        String positiveAction = "",
        String negativeAction = "",
        String neutralAction = "",
        bool backAction = true,
        VoidCallback? onPositivePressed,
        VoidCallback? onNeutralPressed,
        VoidCallback? onNegativePressed}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.bgColor,
          /* shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),*/
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 16, 8),
          // actionsOverflowButtonSpacing: -10,
          title: Visibility(
            visible: title.isNotEmpty,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: CustomTheme.primaryTextStyle.merge(TextStyle(fontSize: 20, color: AppColor.white.withOpacity(0.8))),
              ),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
          content: Text(message, style: CustomTheme.secondaryTextStyle.merge(TextStyle(fontWeight: FontWeight.normal, color: AppColor.white.withOpacity(0.8)))),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            if (negativeAction.isNotEmpty)
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: CustomTheme.primaryTextStyle,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  foregroundColor: AppColor.selectionColor,
                ),
                onPressed: onNegativePressed,
                child: Text(negativeAction, style: CustomTheme.primaryTextStyle.merge(TextStyle(color: AppColor.selectionColor.withOpacity(0.7)))
                ),
              ),
            if (neutralAction.isNotEmpty)
              TextButton(
                style: CustomTheme.secondaryButton,
                onPressed: onNeutralPressed,
                child: Text(neutralAction, style: CustomTheme.primaryTextStyle.merge(TextStyle(color: AppColor.selectionColor.withOpacity(0.7)))
                ),
              ),
            if (positiveAction.isNotEmpty)
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: CustomTheme.primaryTextStyle,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    foregroundColor: AppColor.selectionColor,
                  ),
                  onPressed: onPositivePressed,
                  child: Text(
                    positiveAction,
                    style: CustomTheme.primaryTextStyle.merge(TextStyle(color: AppColor.selectionColor.withOpacity(0.7))),
                  )
              ),
          ],
        );
      },
    );
  }
}
