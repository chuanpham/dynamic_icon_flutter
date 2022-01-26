import 'dart:async';

import 'package:flutter/services.dart';

class DynamicIconFlutter {
  static const MethodChannel _channel = MethodChannel('dynamic_icon_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Indicate whether the current platform supports dynamic app icons
  static Future<bool> get supportsAlternateIcons async {
    final bool supportsAltIcons =
        await _channel.invokeMethod('mSupportsAlternateIcons');
    return supportsAltIcons;
  }

  /// Fetch the current iconName
  ///
  /// Return null if the current icon is the default icon
  static Future<String?> getAlternateIconName() async {
    final String? altIconName =
        await _channel.invokeMethod('mGetAlternateIconName');
    return altIconName;
  }

  /// Set [iconName] as the current icon for the app
  ///
  /// Throw a [PlatformException] with description if
  /// it can't find [iconName] or there's any other error
  static Future setAlternateIconName(String? iconName) async {
    await _channel.invokeMethod(
      'mSetAlternateIconName',
      <String, dynamic>{'iconName': iconName},
    );
  }

  // For Android
  static Future<void> setIcon(
      {required String icon, required List<String> listAvailableIcon}) async {
    Map<String, dynamic> data = {
      'icon': icon,
      'listAvailableIcon': listAvailableIcon
    };
    await _channel.invokeListMethod('setIcon', data);
  }
}
