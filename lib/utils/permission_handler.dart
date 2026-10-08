import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'alert_helper.dart';

class PermissionHandlerService {
  @override
  static Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }
  @override
  static Future<bool> handleCameraPermission(BuildContext context) async {
    PermissionStatus cameraPermissionStatus = await requestCameraPermission();

    if (cameraPermissionStatus == PermissionStatus.denied) {
      AlertHelper.showAlertDialog(context,
          title: 'Camera Permission',
          message: 'Camera permission is required to capture photo. Please enable Camera permission from Settings.',
          positiveAction: 'Ok', onPositivePressed: () async {
            Navigator.pop(context);
            handleCameraPermission(context);
          });
      return false;
    } else if (cameraPermissionStatus == PermissionStatus.permanentlyDenied) {
      AlertHelper.showAlertDialog(context,
          title: 'Camera Permission',
          message: 'Camera permission is required to capture photo. Please enable Camera permission from Settings.',
          positiveAction: 'Ok', onPositivePressed: () async {
            openAppSettings();
            Navigator.of(context).pop();
          });
      return false;
    } else {
      return true;
    }
  }
}
