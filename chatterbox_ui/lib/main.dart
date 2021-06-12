import 'package:chatterbox_ui/styles/theme.dart';
import 'package:flutter/material.dart';
import 'chatterbox.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'models/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  themeInitializer();
  currentTheme = baseTheme;
  runApp(ChatterBox());
}
