import 'package:chatterbox_ui/models/globals.dart';
import 'package:chatterbox_ui/screens/sub_project_pages/project_settings_page.dart';
import 'package:chatterbox_ui/screens/sub_project_settings/chats_settings.dart';
import 'package:chatterbox_ui/screens/sub_project_settings/member_settings.dart';
import 'package:chatterbox_ui/screens/sub_project_settings/project_settings.dart';
import 'package:chatterbox_ui/screens/sub_project_settings/tasks_settings.dart';
import 'package:chatterbox_ui/screens/sub_settings/user_profile.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'navigations.dart';
import 'screens/sub_project_pages/sub_chat_tab/chat_room.dart';
import 'screens/login_screen.dart';
import 'screens/settings.dart';
import 'screens/sub_settings/themepage.dart';
import 'screens/sub_settings/infopage.dart';
import 'screens/project_page.dart';
import 'screens/sub_chatroom/chat_settings.dart';

class ChatterBox extends StatefulWidget {
  @override
  _ChatterBoxState createState() => _ChatterBoxState();
}

class _ChatterBoxState extends State<ChatterBox> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: currentTheme.primaryColor,
        canvasColor: currentTheme.backgroundColor,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _routes(),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final arguments = settings.arguments;

      Widget screen;

      switch (settings.name) {
        case LOGINDIR:
          screen = LoginScreen();
          break;

        case HOMEDIR:
          screen = Home();
          break;

        case CHATDIR:
          screen = Chatroom();
          break;

        case SETTINGSDIR:
          screen = Settings();
          break;

        case settingsThemesDir:
          screen = SettingsThemePage();
          break;

        case settingsProfileDir:
          screen = UserProfile();
          break;

        case settingsInfoDir:
          screen = SettingsInfoPage();
          break;

        case projectDir:
          screen = ProjectPage();
          break;

        case projectSettingsDir:
          screen = ProjectSettingsPage();
          break;

        case chatSettings:
          screen = ChatSettingsPage();
          break;

        case projectSettingsProject:
          screen = ProjectSettingsProjectPage();
          break;

        case projectSettingsMembers:
          screen = ProjectSettingsMembersPage();
          break;

        case projectSettingsTasks:
          screen = ProjectSettingsTasksPage();
          break;

        case projectSettingsChats:
          screen = ProjectSettingsChatsPage();
          break;

        default:
          return null;
      }

      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
