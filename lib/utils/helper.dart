import 'dart:io';

enum DeviceType { android, iOS }

enum APIStatus { success, failure, unauthenticated, noInternet }

enum TaskType { exercise, info, check }


class Helper {

  static Future<bool> isInternetConnectionAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static String getDeviceType() {
    String deviceType;
    if (Platform.isIOS) {
      deviceType = DeviceType.iOS.name;
    } else {
      deviceType = DeviceType.android.name;
    }
    return deviceType;
  }

  static Future<Map<String, String>> getHeaders({bool hasToken = true}) async {
    Map<String, String> headers = {
      'ApiKey': '4a7PhUYdDxbT3W575b',
      'acceptLanguage': 'en',
      'deviceType': getDeviceType()
    };

    return headers;
  }
}