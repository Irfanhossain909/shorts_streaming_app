import 'dart:io';

class DeviceInfoService {
  DeviceInfoService._();
  static final DeviceInfoService _instance = DeviceInfoService._();
  static DeviceInfoService get instance => _instance;
  /// 📱 GET PLATFORM TYPE
  String getPlatformType() {
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS) {
      return "ios";
    } else {
      return "unknown";
    }
  }
}
