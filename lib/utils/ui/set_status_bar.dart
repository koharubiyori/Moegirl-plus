import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setStatusBarColor(Color color) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: color)
  );
}

void setStatusBarVisible(bool visible) {
  SystemChrome.setEnabledSystemUIOverlays([
    if (visible) SystemUiOverlay.top,
    SystemUiOverlay.bottom
  ]);
}

void setStatusBarTextBrightness(Brightness brightness) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarIconBrightness: brightness)
  );
}

void setNavigationBarStyle(Color backgroundColor, Brightness iconBrightness) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: backgroundColor,
      systemNavigationBarIconBrightness: iconBrightness
    )
  );
}

// class StatusBarConfig {
//   bool visible;
//   Color color;
//   Brightness brightness;

//   StatusBarConfig({
//     this.visible = true,
//     this.color = Colors.grey,
//     this.brightness = Brightness.light
//   });
// }

// mixin StatusBarConfigurable<T extends StatefulWidget> on State<T> {
//   bool _visible = true;
//   Color _color = Colors.green;
//   Brightness _brightness = Brightness.light;

//   @override
//   void reassemble() {
//     super.reassemble();
//   }

//   void configureStatusBar({
//     bool visible,
//     Color color,
//     Brightness brightness
//   }) {
//     _visible = visible ?? _visible;
//     _color = color ?? _color;
//     _brightness = brightness ?? _brightness;
//   }

//   Widget build(BuildContext context) {
//     print('build');
//     setStatusBarVisible(_visible);
//     setStatusBarColor(_color);
//     setStatusBarTextBrightness(_brightness);
//     return super.build(context);
//   }
// }