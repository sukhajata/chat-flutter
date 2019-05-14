import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:everyday_language/pages/root_page.dart';
import 'config/settings.dart';
import 'config/translations.dart';

final language = appvars['firstLanguage'] == 'en' ? english : thai;

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

void main() {
  
  runApp(
    new MaterialApp(
      title: language['title'],
      theme: defaultTargetPlatform == TargetPlatform.iOS
        ? kIOSTheme
        : kDefaultTheme,
      home: new RootPage(),
    )
  );
  
}
